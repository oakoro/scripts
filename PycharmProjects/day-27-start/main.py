import tkinter
from tkinter import Entry

window = tkinter.Tk()
window.title("My First GUI Program")
window.minsize(width=500, height=300)
window.config(padx=100, pady=200)


#Label

my_label = tkinter.Label(text="I Am a Label", font=("Arial", 24, "bold"))
# my_label.pack()
# my_label.pack(side="left")

my_label["text"] = "New Text"
my_label.config(text="New Text2")
my_label.grid(column=0, row=0)
my_label.config(padx=50, pady=20)

#Button

def button_click():
    print("I got clicked")
    #my_label.config(text="Button Got Clicked")
    my_label.config(text=input.get())


button = tkinter.Button(text="Click Me", command=button_click,)
# button.pack()
button.grid(column=1, row=1)

new_button = tkinter.Button(text="New Button")
new_button.grid(column=2, row=0)

#Entry -- essentially input

input = Entry(width=10)
# input.pack()
input.grid(column=3, row=2)
input.get()


window.mainloop()