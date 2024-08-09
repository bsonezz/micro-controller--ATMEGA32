#define F_CPU 8000000UL
#include <mega32.h>
#include <delay.h>

int minutes = 0;
int seconds = 0;
int counting_active = 0;
int paused = 0;
int input_stage = 0;
int digit_count = 0;
int pos = -1;
int show_time = 0;
int display_index = 0;

unsigned char led_pattern[7] = {
    0b01000001, 0b00100010, 0b00010100, 0b00001000,
    0b00010100, 0b00100010, 0b01000001
};

int seg[] = {~0x3F, ~0x06, ~0x5B, ~0x4F, ~0x66, ~0x6D, ~0x7D, ~0x07, ~0x7F, ~0x6F};

char ref[] = {0xFE, 0xFD, 0xFB, 0xF7};
int i = 0, segref = 0x01;

char keys[] = { '7', '8', '9', '/', 
                '4', '5', '6', '*',
                '1', '2', '3', '-', 
                'C', '0', '=', '+'};

void display_value(int min, int sec, int show_sec);
void buzzer_and_led_pattern(void);
void handle_keypad_input(void);
void short_buzzer_beep(void);

interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
    if (counting_active && !paused) {
        if (seconds == 0) {
            if (minutes > 0) {
                minutes--;
                seconds = 59;
            } else {
                counting_active = 0;
                buzzer_and_led_pattern();
            }
        } else {
            seconds--;
        }
    }
}

interrupt [TIM0_COMP] void timer0_comp_isr(void) {
    display_value(minutes, seconds, counting_active || paused || show_time);  
    segref <<= 1; 
    i++; 
    if (i == 4) {
        i = 0;
        segref = 0x01;
    }
}

void display_value(int min, int sec, int show_sec) {
    int min_tens = min / 10;
    int min_units = min % 10;

    //condition ? expression_if_true : expression_if_false;
    int sec_tens = (show_sec) ? (sec / 10) : 0;
    int sec_units = (show_sec) ? (sec % 10) : 0;

    // all segments are turned off before updating
    PORTC = 0xFF;
    PORTD = 0x00;

    switch (display_index % 4) {
        case 0:
            PORTC = seg[min_tens];
            PORTD = (1 << display_index); // Active high for the selected digit
            break;
        case 1:
            PORTC = seg[min_units];
            PORTD = (1 << display_index); // Active high for the selected digit
            break;
        case 2:
            PORTC = seg[sec_tens];
            PORTD = (1 << display_index); // Active high for the selected digit
            break;
        case 3:
            PORTC = seg[sec_units];
            PORTD = (1 << display_index); // Active high for the selected digit
            break;
    }

    display_index = (display_index + 1) % 4;
}

void buzzer_and_led_pattern(void) {
    int k, j;
    for (k = 0; k < 1; k++) {
        PORTB |= (1 << PORTB7);
        delay_ms(300);
        PORTB &= ~(1 << PORTB7);
        for (j = 0; j < 7; j++) {
            PORTB = (PORTB & ~(0x7F)) | led_pattern[j]; // clears the lower 7
            delay_ms(50);
        }
    }
}

void handle_keypad_input(void) {
    char key = 0; // pressed key
    int row, col = -1; // no key initialized

    for (row = 0; row < 4; row++) {
        PORTA = ref[row]; // scan keypad
        delay_us(50);

        // column detection
        if (!(PINA & (1 << PINA4))) { col = 0; break; }
        if (!(PINA & (1 << PINA5))) { col = 1; break; }
        if (!(PINA & (1 << PINA6))) { col = 2; break; }
        if (!(PINA & (1 << PINA7))) { col = 3; break; }
    }

    if (col != -1) {
        pos = row * 4 + col;
        key = keys[pos];

        short_buzzer_beep();

        if (key >= '0' && key <= '9') {
            // input_stage 0 is minute
            // input stage 1 seconds
            if (input_stage == 0) {
                if (digit_count == 0) {
                    minutes = (key - '0');
                    digit_count++;
                } else if (digit_count == 1) {
                    minutes = minutes * 10 + (key - '0');
                    if (minutes >= 60) minutes = 59; // if overflow range set to 59
                    input_stage = 1;
                    digit_count = 0;
                }
            } else {
                if (digit_count == 0) {
                    seconds = (key - '0') * 10;
                    digit_count++;
                } else if (digit_count == 1) {
                    seconds += (key - '0');
                    if (seconds >= 60) seconds = 59;
                    digit_count = 0;
                }
            }
            display_value(minutes, seconds, 0);
            show_time = 0;
        } else if (key == 'C') {
            if (show_time) {
                counting_active = 1;
                show_time = 0;
            }
        } else if (key == '/') {
            if (counting_active) {
                paused = !paused;
            }
        } else if (key == '=') {
            if (!counting_active && (minutes > 0 || seconds > 0)) {
                show_time = 1;
                display_value(minutes, seconds, 1);
            }
        } else if (key == '*') {
            minutes = 0;
            seconds = 0;
            input_stage = 0;
            digit_count = 0;
            counting_active = 0;
            paused = 0;
            show_time = 0;
            display_value(minutes, seconds, 0);
        } else if (key == '-') {
            if (input_stage == 1 && digit_count > 0) {
                seconds = seconds / 10;
                digit_count--;
            } else if (input_stage == 1 && digit_count == 0) {
                input_stage = 0;
                digit_count = 2;
            } else if (input_stage == 0 && digit_count > 0) {
                minutes = minutes / 10;
                digit_count--;
            }
            display_value(minutes, seconds, 1);
            show_time = 0;
        }

        while (!(PINA & (1 << PINA4)) || !(PINA & (1 << PINA5)) || !(PINA & (1 << PINA6)) || !(PINA & (1 << PINA7))) {
            delay_ms(10);
        }
    }
}

void short_buzzer_beep(void) {
    PORTB |= (1 << PORTB7);
    delay_ms(20);
    PORTB &= ~(1 << PORTB7);
}

void main(void) {
    DDRC = 0xFF;
    PORTC = 0xFF;
    DDRD = 0xFF;
    PORTD = 0x00;
    DDRB = 0xFF;
    PORTB = 0x00;
    DDRA = 0x0F;
    PORTA = 0xF0;

    TCCR1B |= (1 << WGM12) | (1 << CS12) | (1 << CS10);
    OCR1A = 7811;  //7811 1 second delay, Timer1, 1024 prescaler    ((fcpu*time)/(presc))-1
    TIMSK |= (1 << OCIE1A);

    TCCR0 |= (1 << WGM01) | (1 << CS01) | (1 << CS00);
    OCR0 =  0x4D;
    //0x4D;  // 10 ms delay, Timer0, 64 prescaler
    TIMSK |= (1 << OCIE0);  
    
    
    

    #asm("sei");

    while (1) {
        handle_keypad_input();  
    }
}
