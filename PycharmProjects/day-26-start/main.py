# list = ['9','0','32','8','2','8','64','29','42','99']
# numbers = [int(num) for num in list]
# result = [num for num in numbers if num%2 > 0]
# print(result)
import csv

import pandas

# with open("file1.txt") as file1:
#     data = csv.reader(file1)
#     print(data)
#     new_text1 = [num for num in data]
#     final_list = [int(n) for n in new_text1]
#     print(final_list)

# sentence = "What is the Airspeed Velocity of an unladen Swallow"
# # sentence_dict = sentence.split()
# # print(sentence_dict)
# result = {word: len(word) for (word) in sentence.split()}
# print(result)

# weather_c = {"Mon": 12, "Tue": 14, "Wed": 15}
# weather_f = {day: (value * 9/5) + 32 for (day, value) in weather_c.items()}
# print(weather_f)

student_dict = {
    "student": ["Angela","James", "Lily"],
    "score": [56, 76, 98]
    }
#Looping thru dictionary
for (key, value) in student_dict.items():
    print(key)

import pandas

student_df = pandas.DataFrame(student_dict)
print(student_df)

#Looping thru data frames --- Not very useful
for (key, value) in student_df.items():
    print(value)

#Looping thru rows of a data frame
for (index, row) in student_df.iterrows():
    print(row.student)

