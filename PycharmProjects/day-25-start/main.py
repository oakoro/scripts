# with open("weather_data.csv") as weather_file:
#     print(weather_file.readlines())
import pandas

# import csv
#
#
# with open("weather_data.csv") as weather_file:
#     data = csv.reader(weather_file)
#     print(data)
#     temperature = []
#     for i in data:
#         temp = i[1]
#         #print(temp)
#         if temp != "temp":
#             temperature.append(int(temp))
#         # test = int(input("What is my name"))
#         # print(test)
#     print(temperature)

# import pandas
# from numpy.ma.extras import average
#
# data = pandas.read_csv("weather_data.csv")
# print(type(data))
# print(data)
# temp = data["temp"]
# print(temp)
#
# temp_list = temp.tolist()
# print(average(temp_list))
#
# data_temp = data["temp"].mean()
# print(f"{data_temp}, {data["temp"].max()}")
#
# print(data.day)
#
# #Get Data in Row
# print(data[data.day == "Monday"])
# print(data[data.temp == data["temp"].max()])
#
# monday = data[data.day == "Monday"]
# print(monday.condition)
#
# mon_temp = float(monday.temp)
# temp_conv = (mon_temp * 9/5) + 32
# print(temp_conv)


#Create a datafrane

# data_dict = {
#     "student": ["Amy", "James", "Angela"],
#     "score": [76, 56, 65]
# }
# data = pandas.DataFrame(data_dict)
# print(data)
#
# data.to_csv("new_data,csv")

data = pandas.read_csv("2018_Central_Park_Squirrel_Census_-_Squirrel_Data_20250203.csv")
# headers = data.head()
# print(headers)
grey_squirrels = len(data[data["Primary Fur Color"] == "Gray"])
red_squirrels = len(data[data["Primary Fur Color"] == "Red"])
black_squirrels = len(data[data["Primary Fur Color"] == "Black"])

data_dict = {
    "Fur Color": ["Gray", "Cinnamon", "Black"],
    "Count": [grey_squirrels, red_squirrels, black_squirrels]
}

df = pandas.DataFrame(data_dict)
df.to_csv("Squirrel_count.csv")
print(df)
