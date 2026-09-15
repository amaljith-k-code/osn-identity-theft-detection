from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class usertable(models.Model):
    LOGIN=models.ForeignKey(User,on_delete=models.CASCADE)
    name= models.CharField(max_length=100)
    email= models.CharField(max_length=100)
    phone= models.BigIntegerField()
    DOB= models.DateField()
    gender= models.CharField(max_length=100)
    photo= models.FileField()
    status= models.CharField(max_length=100,default="active")

class complainttable(models.Model):
    USER=models.ForeignKey(usertable,on_delete=models.CASCADE)
    Date= models.DateField()
    complaints= models.CharField(max_length=100)
    reply= models.CharField(max_length=100)
    status= models.CharField(max_length=100)

class feedbacktable (models.Model):
    USER = models.ForeignKey(usertable, on_delete=models.CASCADE)
    Date= models.DateField()
    feedback= models.CharField(max_length=1000)
    rating= models.CharField(max_length=1000)

class requesttable (models.Model):
    Date= models.DateField()
    status= models.CharField(max_length=100)
    fromuser= models.ForeignKey(usertable,on_delete=models.CASCADE,related_name='ab')
    touser=models.ForeignKey(User,on_delete=models.CASCADE,related_name='ba')



class ChatTable(models.Model):

    SENDER=models.ForeignKey(User, on_delete=models.CASCADE,related_name='SENDER')

    RECEIVER=models.ForeignKey(User, on_delete=models.CASCADE,related_name='RECEIVER')

    message=models.TextField()

    date=models.DateField(auto_now_add=True)

    time=models.TimeField(auto_now_add=True)

    is_read=models.BooleanField(default=False)

class posttable (models.Model):
    USER= models.ForeignKey(usertable,on_delete=models.CASCADE)
    image = models.FileField()
    description= models.CharField(max_length=100)
    caption= models.CharField(max_length=100)
    date= models.DateField()

class commenttable (models.Model):
    USER= models.ForeignKey(usertable,on_delete=models.CASCADE)
    post= models.ForeignKey(posttable,on_delete=models.CASCADE)
    comment= models.CharField(max_length=500)
    date= models.DateField()
    type= models.CharField(max_length=100)

class liketable (models.Model):
    USER = models.ForeignKey(usertable, on_delete=models.CASCADE)
    post = models.ForeignKey(posttable, on_delete=models.CASCADE)
    like_dislike= models.CharField(max_length=100)
    date= models.DateField()

class commentreply (models.Model):
    USER = models.ForeignKey(usertable, on_delete=models.CASCADE)
    comment = models.ForeignKey(commenttable, on_delete=models.CASCADE)
    reply = models.CharField(max_length=100)
    date= models.DateField()
    time= models.TimeField()

class postnotification (models.Model):
    USER = models.ForeignKey(usertable, on_delete=models.CASCADE)
    post = models.ForeignKey(posttable, on_delete=models.CASCADE)
    date = models.DateField()
    status = models.CharField(max_length=100)
    # bottom = models.CharField(max_length=100)
    # right = models.CharField(max_length=100)
    # left = models.CharField(max_length=100)
    # top = models.CharField(max_length=100)

class expert(models.Model):
    LOGIN = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    phone = models.BigIntegerField()
    DOB = models.DateField()
    gender = models.CharField(max_length=100)
    photo = models.FileField()
    status = models.CharField(max_length=100)
    place = models.CharField(max_length=100)


class DoubtTable(models.Model):
    USER=models.ForeignKey(usertable,on_delete=models.CASCADE)
    EXPERT=models.ForeignKey(expert,on_delete=models.CASCADE)
    doubt=models.CharField(max_length=200)
    reply=models.CharField(max_length=200)
    date=models.DateField()

class TipsTable(models.Model):
    EXPERT=models.ForeignKey(expert,on_delete=models.CASCADE)
    tip=models.CharField(max_length=500)
    details=models.CharField(max_length=500)
    date=models.DateField()
