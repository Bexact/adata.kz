import requests
from bs4 import BeautifulSoup
import pandas as pd
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

url = "https://www.goszakup.gov.kz/ru/registry/rqc"
response = requests.get(url, verify=False)

if response.status_code == 200:
    soup = BeautifulSoup(response.text, 'html.parser')
else:
    print("Failed to access the page.")
    exit()

rows = soup.find('table').find_all('tr')

headers = [col.text.strip() for col in soup.find('table').find_all('th')]

data = []
addresses = []

for row in rows[1:]:  
    cols = row.find_all('td')
    a = row.find_all('a')
    cols = [col.text.strip() for col in cols]

    boss = {}  
    address = ""  

    for item in a:
        item_url = item.get('href')
        response = requests.get(item_url, verify=False)

        if response.status_code == 200:
            soup_detail = BeautifulSoup(response.text, 'html.parser')  
        else:
            print(f"Failed to access URL: {item_url}")
            continue 

        h4_elements = soup_detail.find_all('h4')

        for h4 in h4_elements:
            if h4.text == 'Руководитель':
                table = h4.find_next('table')
                if table:
                    rows = table.find_all('tr')
                    for row in rows:
                        header_cell = row.find('th')
                        data_cell = row.find('td')

                        if header_cell and data_cell:
                            header_text = header_cell.get_text(strip=True)
                            data_text = data_cell.get_text(strip=True)

                            if header_text == 'ИИН' or header_text == 'ФИО':
                                boss[header_text] = data_text

            if h4.text == 'Контактная информация':
                table = h4.find_next('table')
                if table:
                    rows = table.find_all('tr')

                    for row in rows[1:]:
                        data_cell = row.find_all('td')[2]

                        if data_cell:
                            address = data_cell.get_text(strip=True)

  
    data.append(cols + [boss.get('ИИН', ''), boss.get('ФИО', '')])
    addresses.append(address)  

while len(addresses) < len(data):
    addresses.append('')

df = pd.DataFrame(data, columns=headers + ['ИИН', 'ФИО'])
df['Полный адрес организации'] = addresses

df = df.drop(columns=['№','Наименование, номер и дата выдачи документа, на основании которого потенциальный поставщик включен в Перечень'])

unique_df = df.drop_duplicates(subset=['БИН/ИИН'])

print(unique_df)
unique_df.to_excel('final1.xlsx', index=False) 
