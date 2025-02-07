from tkinter import *
import math
# ---------------------------- CONSTANTS ------------------------------- #
PINK = "#e2979c"
RED = "#e7305b"
GREEN = "#9bdeac"
YELLOW = "#f7f5dd"
FONT_NAME = "Courier"
WORK_MIN = 25
SHORT_BREAK_MIN = 5
LONG_BREAK_MIN = 20

# ---------------------------- TIMER RESET ------------------------------- # 

# ---------------------------- TIMER MECHANISM ------------------------------- # 
def starr_timer():
    count_down(5 * 60)

    global reps
    reps += 1

# ---------------------------- COUNTDOWN MECHANISM ------------------------------- # `
#Option 1 - import time
#Option 2 - Use event driven
def count_down(count):
    #print(count)
    count_min = math.floor(count/60)
    count_sec = count % 60
    if count_sec == 0:
        count_sec = "00"
    # canvas.itemconfig(timer_text, text=count)
    canvas.itemconfig(timer_text, text=f"{count_min}:{count_sec}")
    if count > 0:
        window.after(1000, count_down, count -1)


# ---------------------------- UI SETUP ------------------------------- #

window = Tk()
window.title("Pomodoro")
window.config(padx=100,pady=50, bg=YELLOW)





#Create canvas
canvas = Canvas(width=200, height=224, bg=YELLOW, highlightthickness=0)
tomato_img = PhotoImage(file="tomato.png")
canvas.create_image(100, 112, image=tomato_img)
timer_text = canvas.create_text(100,130,text="00:00", fill="white", font=(FONT_NAME, 35, "bold"))
# canvas.pack()
canvas.grid(column=1,row=1)



timer_label = Label(text="Timer",font=(FONT_NAME,50),fg=GREEN, bg=YELLOW)
timer_label.grid(column=1, row=0)



start_button = Button(text="Start",highlightthickness=0, command=starr_timer)
start_button.grid(column=0, row=2)

reset_button = Button(text="Reset",highlightthickness=0)
reset_button.grid(column=2, row=2)

check_mark = Label(text="✔️",fg=GREEN,bg=YELLOW)
check_mark.grid(column=1, row=3)


window.mainloop()