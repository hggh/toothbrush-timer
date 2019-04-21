#include <Arduino.h>
#include <avr/sleep.h>
#include <TM1637Display.h>
#include <Bounce2.h>

#define BUTTON_PIN 4
#define DISPLAY_CLK 1
#define DISPLAY_DIO 0
#define TIMER_SECONDS 150

Bounce button = Bounce();
TM1637Display display(DISPLAY_CLK, DISPLAY_DIO);

short button_mode = 0;
volatile int timer_countdown = 0;
volatile int last_timer_countdown = 0;
volatile unsigned long wakup_time = 0;
volatile short goto_sleep_now = 0;

ISR(PCINT0_vect) {
  wakup_time = millis();
}

ISR(TIMER1_COMPA_vect) {
  timer_countdown--;
  if (timer_countdown == 0) {
    goto_sleep_now = 1;
  } 
}

int secondsToDisplay(int i) {
  int h = i / 60;

  return (h * 100) + (i - (h*60));
}

void setup_timer1() {
  noInterrupts();
  // timer1 every 1s
  GTCCR = _BV(PSR1);
  TCNT1 = 0;
  TCCR1 = 0;
  TCCR1 |= (1 << CTC1);
  TCCR1 |= (1 << CS13) | (1 << CS12) | (1 << CS10);
  OCR1C = 243;
  TIMSK |= (1 << OCIE1A);
  interrupts();
}

void disable_timer1() {
  noInterrupts();
  GTCCR = _BV(PSR1);
  TCNT1 = 0;
  TCCR1 = 0;
  interrupts();
}

void goto_sleep() {
  disable_timer1();

  display.clear();

  set_sleep_mode(SLEEP_MODE_PWR_DOWN);
  sleep_enable();
  sleep_mode();
  sleep_disable();
}

void enable_display() {
  display.setBrightness(4);
}

void setup() {
  ADCSRA &=(~(1 << ADEN));
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  button.attach(BUTTON_PIN);
  button.interval(25);

  noInterrupts();
  GIMSK |= (1 << PCIE);
  PCMSK |= (1 << PCINT4);
  interrupts();

  wakup_time = millis();
}

void loop() {
  button.update();

  if (button.rose()) {
    if (button.previousDuration() < 1024) {
      button_mode = 1;
    }
    else {
      button_mode = 2;
    }
  }

  if (button_mode == 1) {
    timer_countdown = TIMER_SECONDS;
    button_mode = 0;
    setup_timer1();
    enable_display();
  }
  if (button_mode == 2) {
    button_mode = 0;
    // long press goto sleep
    goto_sleep();
  }

  if (timer_countdown > 0 && timer_countdown != last_timer_countdown) {
    // update display only if time changed
    display.showNumberDecEx(secondsToDisplay(timer_countdown), 64, true);
    last_timer_countdown = timer_countdown;
  }

  if (goto_sleep_now == 1) {
    goto_sleep_now = 0;
    goto_sleep();
  }

  if (millis() - wakup_time >= 4000 && timer_countdown == 0) {
    goto_sleep();
  }
}
