import turtle
from turtle import Turtle, Screen
import random

tim = Turtle()
num_sides = 5
turtle.colormode(255)


def random_color():
    r = random.randint(0, 255)
    g = random.randint(0, 255)
    b = random.randint(0, 255)
    color = (r, g, b)
    return color


print(random_color())
colours = ["red", "yellow", "green", "cyan", "magenta", "black"]
direction = [0, 90, 180, 270]
# tim.pensize(20)
tim.speed("fastest")

angle = 360 / num_sides


def draw_spiragraph(size_of_gap):
    for _ in range(int(360 /size_of_gap)):
        tim.color(random_color())
        tim.circle(100)
        current_heading = tim.heading()
        tim.setheading((current_heading + 10))
        tim.circle(100)

draw_spiragraph(5)

# for i in range(200):
#     #tim.color(random.choice(colours))
#     tim.color(random_color())
#     tim.forward(30)
#     tim.setheading(random.choice(direction))

#
#
# def draw_shape(num_sides):
#     angle = 360 / num_sides
#     for _ in range(num_sides):
#         tim.forward(100)
#         tim.right(angle)
#
# for shape_side_n in range(3,11):
#     tim.color(random.choice(colours))
#     draw_shape(shape_side_n)


# tim.color("black", "red")
# tim.begin_fill()
# tim.forward(200)
# tim.back(100)
# tim.right(90)
# tim.forward(100)
# tim.right(90)
# tim.forward(100)
# tim.right(90)
# tim.forward(100)
# tim.fillcolor("red")
# tim.end_fill()

# for _ in range(10):
#     tim.pendown()
#     tim.forward(10)
#     tim.penup()
#     tim.forward(10)


# for _ in range(4):
#     tim.forward(100)
#     tim.left(90)
# timmy_the_turtle.forward(100)
# timmy_the_turtle.left(90)
# timmy_the_turtle.forward(100)
# timmy_the_turtle.left(90)
# timmy_the_turtle.forward(100)
screen = Screen()
screen.exitonclick()
