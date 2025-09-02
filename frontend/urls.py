# URLs del Frontend (para GitHub Pages)
from django.urls import path
from . import views

urlpatterns = [
    path('', views.home_github_pages, name='home_github_pages'),
    path('index.html', views.home_github_pages, name='home_github_pages_index'),
]