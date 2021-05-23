from django.shortcuts import render, HttpResponse
from tool import models


def type_list(request):
    type_all = models.Type.objects.all()
    return render(request,'type_list.html', {'type_all': type_all})

# Create your views here.
