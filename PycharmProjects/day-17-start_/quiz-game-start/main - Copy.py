from question_model import Question
from data import question_data
from quiz_brain import QuizBrain

question_bank = []

for i in question_data:
    #print(i)
    #question_bank.append(i)
    question_text = i["text"]
    question_answer = i["answer"]
    new_question = Question(question_text, question_answer)
    question_bank.append(new_question)

quiz = QuizBrain(question_bank)

while quiz.still_has_questions():
    quiz.next_question()
#print(question_bank[2])
# print(question_bank)
# print(question_bank[0].answer)

