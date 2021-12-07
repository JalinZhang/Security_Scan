#!/usr/bin/env python3
# _*_ coding:utf-8 _*_
from prompt_toolkit import print_formatted_text as print
from config.banner import banner
from config.console import Weblogic_Console
print('''
                                                                                         
 _____                      _ _           _____                  
/  ___|                    (_) |         /  ___|                 
\ `--.  ___  ___ _   _ _ __ _| |_ _   _  \ `--.  __ _  ___ _ __  
 `--. \/ _ \/ __| | | | '__| | __| | | |  `--. \/ _` |/ __| '_ \ 
/\__/ /  __/ (__| |_| | |  | | |_| |_| | /\__/ / (_| | (__| | | |
\____/ \___|\___|\__,_|_|  |_|\__|\__, | \____/ \__,_|\___|_| |_|
                                   __/ |                         
                                  |___/                         
                                    ——————   By JalinZhang | v1.0                                
''')



def run():
    print('Welcome To SecurityScan Tool !!!\n Readme：https://github.com/JalinZhang/Security_Scan')
    print(banner)
    Weblogic_Console()

if __name__ == '__main__':
    run()
