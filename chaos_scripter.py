import time
import sys
import threading
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import requests

pause_thread = False
stop_thread = False
animation_thread = None

def loading_animation():
    while not stop_thread:
        for frame in "|/-\\":
            if stop_thread:
                break
            sys.stdout.write(f"\rRunning {frame}")
            sys.stdout.flush()
            time.sleep(0.2)
    sys.stdout.write("\r")

def check_script():
    print("Checando script...")
    time.sleep(2)
    print("Script checado com sucesso!")

def ask_proceed(script_name):
    while True:
        response = input(f"Você quer prosseguir com o script {script_name} (s/n)? ").lower()
        if response in ['s', 'n']:
            return response == 's'
        print("Resposta inválida. Por favor, digite 's' para sim ou 'n' para não.")

def ask_num_processes():
    while True:
        try:
            num_processes = int(input("Número de processos de automação (entre 1 e 10): "))
            if 1 <= num_processes <= 10:
                return num_processes
            else:
                print("Número fora do intervalo. Por favor, escolha entre 1 e 10.")
        except ValueError:
            print("Entrada inválida. Por favor, digite um número inteiro entre 1 e 10.")

def get_user_data(process_num):
    print(f"\nColetando dados para o processo {process_num}:")
    email = input("Email: ")
    password = input("Senha: ")
    card_number = input("Número do Cartão: ")
    return email, password, card_number

def start_automation(email, password, card_number):
    firefox_options = Options()
    firefox_options.headless = True

    driver = webdriver.Firefox(options=firefox_options)
    
    try:
        driver.get("https://www.sef.pt/pt/Pages/Homepage.aspx")
        print("Título da página:", driver.title)

        buttonLOGIN = WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.CLASS_NAME, "login-launcher"))
        )
        buttonLOGIN.click()
        print("Botão 'LOGIN' foi clicado com sucesso!")

        campo_user = driver.find_element(By.ID, "txtUsername")
        campo_user.send_keys(email)
        campo_pass = driver.find_element(By.ID, "txtPassword")
        campo_pass.send_keys(password)
        print("Formulário de login foi preenchido com sucesso!")

        buttonENTRAR = WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ID, "btnLogin"))
        )
        buttonENTRAR.click()
        print("Botão 'ENTRAR' foi clicado com sucesso!")

        buttonRENOVAR = WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ID, "renovacaoAutomaticaLink"))
        )
        buttonRENOVAR.click()
        print("Botão 'Renovação Automática' foi clicado com sucesso!")

        campo_pass2 = driver.find_element(By.ID, "txtAuthPanelPassword")
        campo_pass2.clear()
        campo_pass2.send_keys(password)
        campo_NUMCARD = driver.find_element(By.ID, "txtAuthPanelDocument")
        campo_NUMCARD.clear()
        campo_NUMCARD.send_keys(card_number)
        print("Formulário de renovação foi preenchido com sucesso!")

        buttonAUTENTICAR = WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ID, "btnAutenticaUtilizador"))
        )
        buttonAUTENTICAR.click()
        print("Botão 'AUTENTICAR' foi clicado com sucesso!")

        time.sleep(2)
        print("Automação concluída com sucesso para o email:", email)

    except Exception as e:
        print(f"Ocorreu um erro durante a execução para o email {email}: {e}")
        return False

    finally:
        driver.quit()

    return True

def check_internet():
    try:
        requests.get("http://www.google.com", timeout=5)
        return True
    except requests.ConnectionError:
        return False

def pause_automation():
    global pause_thread
    pause_thread = not pause_thread
    if pause_thread:
        print("Automação pausada. Digite novos dados para continuar.")
    else:
        print("Automação retomada.")

def main():
    global animation_thread, stop_thread
    print("Bem-vindo ao ChaosScripter\n")
    
    # Etapa 1: Loading
    print("Carregando script...")
    loading_thread = threading.Thread(target=loading_animation)
    loading_thread.start()
    time.sleep(3)
    stop_thread = True
    loading_thread.join()
    
    # Etapa 2: Checar script
    check_script()
    
    # Etapa 3: Perguntar para prosseguir
    if not ask_proceed("ChaosScripter"):
        print("Operação cancelada pelo usuário.")
        return
    
    # Etapa 4: Número de processos de automação
    num_processes = ask_num_processes()
    
    # Etapa 5: Coleta de dados cadastrais
    user_data = []
    for i in range(1, num_processes + 1):
        data = get_user_data(i)
        user_data.append(data)
    
    # Início da automação
    print("\nIniciando automação...\n")
    animation_thread = threading.Thread(target=loading_animation)
    animation_thread.start()
    
    while True:
        process_index = 0
        while process_index < len(user_data):
            email, password, card_number = user_data[process_index]
            print(f"Processo {process_index + 1}: Email={email}")
            
            while not check_internet():
                print("Sem conexão com a internet. Tentando reconectar...")
                time.sleep(5)
            
            success = start_automation(email, password, card_number)
            if not success:
                print(f"Erro no processo {process_index + 1} com o email {email}. Excluindo da lista.")
                user_data.pop(process_index)
            else:
                print(f"Processo {process_index + 1} concluído com sucesso.\n")
                process_index += 1
            
            if pause_thread:
                while pause_thread:
                    time.sleep(1)
                new_data = get_user_data(process_index + 1)
                user_data.append(new_data)
        
        if stop_thread:
            break
    
    animation_thread.join()
    
    # Perguntar se o usuário quer terminar o processo por completo
    while True:
        response = input("Você deseja terminar o processo por completo? Isso requer reentrar todos os dados novamente (s/n): ").lower()
        if response == 's':
            print("Processo terminado pelo usuário.")
            break
        elif response == 'n':
            print("Processo continuará.")
            continue
        else:
            print("Resposta inválida. Por favor, digite 's' para sim ou 'n' para não.")

if __name__ == "__main__":
    threading.Thread(target=main).start()

    while True:
        command = input("Digite 'pause' para pausar/retomar ou 'stop' para cancelar automação: ").lower()
        if command == "pause":
            pause_automation()
        elif command == "stop":
            response = input("Você deseja terminar o processo por completo? Isso requer reentrar todos os dados novamente (s/n): ").lower()
            if response == 's':
                print("Automação cancelada pelo usuário.")
                stop_thread = True
                if animation_thread:
                    animation_thread.join()
                break
            elif response == 'n':
                print("Automação continuará.")
