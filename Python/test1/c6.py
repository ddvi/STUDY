class Student():
    # 类变量
    su = 0
    score = 0

    def __init__(self, name, age):
        self.name = name
        self.age = age
        self.__class__.su += 1

    def marking(self, score):
        self.score = score
        print(self.name + '同学本次考试分数为：' + str(self.score))
    def do_english_homework():
        print("englishhomework")
    def do_homework(self):
        self.do_english_homework(self)
        print('homework')
    @classmethod
    def plus_su(cls):
        cls.su += 1
        print("当前班级总人数为： " + str(cls.su))
    @staticmethod
    def add(x, y):
        print(Student.su)
        print('this is a static method')
student1=Student('a', 1)
student1.marking(59)
