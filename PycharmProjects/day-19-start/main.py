from turtle import Turtle, Screen

#tim = Turtle()
screen = Screen()
#
# def move_forward():
#     tim.forward(10)
#
# def move_backward():
#     tim.backward(10)
#
# def move_clockwise():
#     tim.right(60)
#
# def move_anticlockwise():
#     tim.left(25)
#
# def cleardrawing():
#     tim.clear()
#
# screen.listen()
# screen.onkey(key="w",fun=move_forward)
# screen.onkey(key="s",fun=move_backward)
# screen.onkey(key="a",fun=move_anticlockwise)
# screen.onkey(key="d",fun=move_clockwise)
# screen.onkey(key="c",fun=cleardrawing)
# tim.home()
# screen.exitonclick()

screen.setup(width=600,height=600)
screen.bgcolor("black")
screen.title("My Snake Game")

starting_positions = [(0, 0), (-20, 0), (-40, 0)]
segment = []

for position in starting_positions:
    new_segment = Turtle("square")
    new_segment.color("white")
    new_segment.penup()
    new_segment.goto(position)
    segment.append(new_segment)

game_is_on = True
while game_is_on:
    for seg in segment:
        seg.forward(20)



# print(segment)
# segment_2 = Turtle("square")
# segment_2.color("white")
# segment_2.goto(-20, 0)
#
# segment_1 = Turtle("square")
# segment_1.color("white")
#
# segment_3 = Turtle("square")
# segment_3.color("white")



screen.exitonclick()