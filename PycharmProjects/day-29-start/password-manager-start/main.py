from tkinter import *
from tkinter import messagebox
import random
import pyperclip

# ---------------------------- PASSWORD GENERATOR ------------------------------- #
def generate_password():

    letters = ["a","b","c","d","e","f","g","h","i"]
    numbers = ["0","1","2","3","4","5","6","7"]
    symbols = ['!','#','%','&','*','+']

    nr_letters = random.randint(8,9)
    nr_symbols = random.randint(2, 4)
    nr_numbers = random.randint(2, 4)

    password_letters = [random.choice(letters) for _ in range(nr_letters)]
    password_symbols = [random.choice(symbols) for _ in range(nr_symbols)]
    password_numbers = [random.choice(numbers) for _ in range(nr_numbers)]

    password_list = password_letters + password_numbers + password_symbols

    random.shuffle(password_list)

    password = "".join(password_list)

    password_input.insert(0, password)
    pyperclip.copy(password)

# ---------------------------- SAVE PASSWORD ------------------------------- #

def save():

    website = website_input.get()
    email = username_input.get()
    password = password_input.get()

    if len(website) == 0 or len(password) == 0:
        messagebox.showinfo(title="Oops", message="Please make sure you haven't left any fields empty.")
    else:
        is_ok = messagebox.askokcancel(title="Title", message=f"These are the details entered: \nEmail: {email}"
                                   f"\nPassword: {password} \nis it ok to save?")

        if is_ok:

            with open("data,text", "a") as data_file:
                data_file.write(f"{website} | {email} | {password}\n")
                website_input.delete(0, END)
                password_input.delete(0, END)



# ---------------------------- UI SETUP ------------------------------- #

window = Tk()
window.title("Password Manager")
window.config(padx=50, pady=50)


canvas = Canvas(width=200, height=200)
pwd_logo = PhotoImage(file="logo.png")
canvas.create_image(100, 100, image=pwd_logo)
canvas.grid(column=1,row=0)

website_label = Label(text="Website")
website_label.grid(column=0, row=1)

username_label = Label(text="Email/Username")
username_label.grid(column=0, row=2)

password_label = Label(text="Password")
password_label.grid(column=0, row=3)

# add_label = Label(text="Add")
# add_label.grid(column=1, row=4)

website_input = Entry(width=35)
website_input.grid(column=1,row=1, columnspan=2)
website_input.focus()

username_input = Entry(width=35)
username_input.grid(column=1,row=2, columnspan=2)
username_input.insert(0, "oke_akoro@hotmail.com")

password_input = Entry(width=17)
password_input.grid(column=1, row=3)

# add_input = Entry(width=36)
# add_input.grid(column=2,row=4,columnspan=2 )

gen_password_button = Button(text="Generate Password",command=generate_password)
gen_password_button.grid(column=2, row=3)

add_button = Button(text="Add",width=30, command=save)
add_button.grid(column=1, row=4, columnspan=2)






window.mainloop()