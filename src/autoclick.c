#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#ifdef __APPLE__
#include <stdlib.h>
#else
#include <X11/Xlib.h>
#include <X11/extensions/XTest.h>
#endif
#endif

void promptDuration(int *duration) {
    printf("Enter duration in seconds (0 for infinite): ");
    scanf("%d", duration);
}

void promptClicksPerMinute(int *clicksPerMinute) {
    printf("Enter clicks per minute (use 60 for clicks per second): ");
    scanf("%d", clicksPerMinute);
}

void calculateInterval(int clicksPerMinute, int *interval) {
    *interval = 60000 / clicksPerMinute; // Interval in milliseconds
}

void mouseClick() {
#ifdef _WIN32
    // Simulate mouse click on Windows
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    Sleep(10); // Small delay for click down
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
#elif __APPLE__
    // Simulate mouse click on macOS using cliclick
    system("cliclick c:.");
#else
    // Simulate mouse click on Linux using XTest
    Display *display = XOpenDisplay(NULL);
    if (display == NULL) {
        fprintf(stderr, "Unable to open display\n");
        exit(EXIT_FAILURE);
    }
    XTestFakeButtonEvent(display, 1, True, 0);
    XTestFakeButtonEvent(display, 1, False, 0);
    XFlush(display);
    XCloseDisplay(display);
#endif
}

void sleepInterval(int interval) {
#ifdef _WIN32
    Sleep(interval); // Sleep in milliseconds
#else
    usleep(interval * 1000); // Sleep in microseconds
#endif
}

int main() {
    int duration = 0;
    int clicksPerMinute = 60;
    int interval = 0;
    int clickCount = 0;
    int maxClicks = 0;

    // Prompt user for duration and clicks per minute
    promptDuration(&duration);
    promptClicksPerMinute(&clicksPerMinute);

    // Calculate interval between clicks
    calculateInterval(clicksPerMinute, &interval);

    // Calculate the maximum number of clicks if duration is finite
    if (duration != 0) {
        maxClicks = (duration * clicksPerMinute) / (60000 / interval);
    } else {
        maxClicks = -1; // Infinite clicks
    }

    printf("Running auto clicker...\n");

    // Start clicking loop
    while (maxClicks == -1 || clickCount < maxClicks) {
        mouseClick(); // Perform mouse click
        clickCount++; // Increment click count
        sleepInterval(interval); // Wait before the next click
    }

    printf("Auto clicker finished.\n");
    return 0;
}
