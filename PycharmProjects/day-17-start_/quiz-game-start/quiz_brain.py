class QuizBrain:

    def __init__(self, q_list):
        self.question_number = 0
        self.question_list = q_list

    def still_has_questions(self):
        # if self.question_number < len(self.question_list):
        #     return True
        # else:
        #     return False
        return self.question_number < len(self.question_list)  #same as above

    def next_question(self):
        current_question = self.question_list[self.question_number]
        self.question_number += 1
        user = input(f"What is the answer for question {self.question_number}: {current_question.text} (True/False)")
        self.check_answer(user_answer, current_question.answer)

    def check_answer(self, user_answer, correct_answer):
        if user_answer.lower() == correct_answer.lower():


