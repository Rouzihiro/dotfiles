#!/usr/bin/env python3
import requests
import sys

# Configurações
API_KEY = "76c322b3531a85272ddfb1140c4d5261"  # Substitua por sua chave
CITY = "Porto Alegre,BR"
UNITS = "metric"
LANG = "pt_br"

# Mapeamento de ícones
ICONS = {
    "01": "☀️",  # Sol
    "02": "⛅",   # Sol com nuvens
    "03": "☁️",   # Nuvens
    "04": "☁️",   # Nuvens pesadas
    "09": "🌧️",   # Chuva
    "10": "🌦️",   # Chuva com sol
    "11": "⛈️",    # Trovoada
    "13": "❄️",    # Neve
    "50": "🌫️"     # Névoa
}

try:
    # Obter dados da API
    url = f"http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}&units={UNITS}&lang={LANG}"
    response = requests.get(url, timeout=5)
    data = response.json()

    if response.status_code == 200:
        temp = round(data['main']['temp'])
        icon_code = data['weather'][0]['icon'][:2]
        icon = ICONS.get(icon_code, "🌍")
        print(f"{icon}{temp}°C")  # Formato final para a barra
    else:
        print("⏳")  # Ícone de loading em caso de erro

except Exception as e:
    print("🌡️")  # Ícone genérico para falha