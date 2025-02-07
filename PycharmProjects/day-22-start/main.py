from turtle import Screen, Turtle
from paddle import Paddle

#Create screen
screen = Screen()
screen.bgcolor("black")
screen.setup(width=800, height=600)
screen.title("Pong")
screen.tracer(0)

r_paddle = Paddle((350, 0))
l_paddle = Paddle((-350, 0))



#Create and move a paddle
# paddle = Turtle()
# paddle.shape("square")
# paddle.color("white")
# paddle.shapesize(stretch_wid=5, stretch_len=1)
# paddle.penup()
# paddle.goto(350, 0)

# def go_up():
#     new_y = paddle.ycor() + 20
#     paddle.goto(paddle.xcor(), new_y)
#
# def go_down():
#     new_y = paddle.ycor() - 20
#     paddle.goto(paddle.xcor(), new_y)

screen.listen()
screen.onkey(r_paddle.go_up(), "Up")
screen.onkey(r_paddle.go_down(), "Down")
screen.onkey(l_paddle.go_up(), "w")
screen.onkey(l_paddle.go_down(), "s")

game_is_on = True
while game_is_on:
    screen.update()




screen.exitonclick()
