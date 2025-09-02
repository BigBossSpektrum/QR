from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth.models import User
from django.conf import settings

# Create your views here.
@login_required
def home(request):
    return render(request, 'home.html')

def home_github_pages(request):
    """Vista principal para GitHub Pages - generador de QR estático"""
    context = {
        'backend_api_url': getattr(settings, 'BACKEND_API_URL', 'https://tu-app.cleverapps.io'),
        'title': 'Generador QR - GitHub Pages'
    }
    return render(request, 'frontend/github_pages.html', context)

def custom_404(request, exception):
    return render(request, '404.html', status=404)

def register_view(request):
    if request.user.is_authenticated:
        return redirect('home')
    
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            username = form.cleaned_data.get('username')
            messages.success(request, f'¡Cuenta creada exitosamente para {username}! Ya puedes iniciar sesión.')
            return redirect('login')
        else:
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f'{field}: {error}')
    else:
        form = UserCreationForm()
    
    return render(request, 'registration/register.html', {'form': form})

def login_view(request):
    if request.user.is_authenticated:
        return redirect('home')
    
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            messages.success(request, f'¡Bienvenido de vuelta, {username}!')
            next_page = request.GET.get('next', 'home')
            return redirect(next_page)
        else:
            messages.error(request, 'Usuario o contraseña incorrectos.')
    
    return render(request, 'registration/login.html')
