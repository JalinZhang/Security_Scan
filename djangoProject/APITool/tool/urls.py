from django.urls import path
from tool import views

urlpatterns = {
    path('type_list/', views.type_list),
}



