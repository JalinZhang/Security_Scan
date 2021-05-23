from django.db import models

# Create your models here.
#请求类型对应的数据表，我们将其映射类取名为 Type
#主键 id
#请求类型的名字 name
class Type(models.Model):
    name = models.CharField(max_length=10, unique=True)
    sex = models.CharField

