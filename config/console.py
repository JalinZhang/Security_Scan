import os
from prompt_toolkit import prompt
from prompt_toolkit.completion import WordCompleter
import argparse

def poc(ip,port,user,password,profile):
    #html_completer = WordCompleter(['<os>', '<nginx>', '<oracle>', '<mysql>','<docker>'])
    #profile = prompt('Enter Profile You Want to Scan: ', completer=html_completer)
    #print('%s will be Scan'%profile)
    print ("[*] =========Task Start=========")
    os.environ['profile']=str(profile)
    os.environ['ip']=str(ip)
    os.environ['user']=str(user)
    os.environ['password']=str(password)
    os.environ['port']=str(port)
    os.system('inspec exec profile/$profile -t ssh://$user:$password@$ip:$port --reporter=cli json:/tmp/scan_$ip$profile,json')
    print ("[*] =========Task E n d=========")

def poolmana (filename,profile):
    fr=open(filename,'r')
    url=fr.readlines()
    fr.close()
    os.environ['profile']=str(profile)
    print ("[*] ========Task Num: [{}]========".format(len(url)))
    for i in url:
        i=i.replace('\n','')
        ip = i.rsplit("@",1)[1]
        ip = ip.split(":")[0]
        os.environ['ip']=str(ip)
        print ("[*] =========Task Begin For: [{}]=========".format(ip))
        os.system('inspec exec profile/$profile -t ssh://$url --reporter json:/tmp/scan_$ip$profile.json')
    print ("[*] ==========Task End==========")

def Weblogic_Console():
    parser = argparse.ArgumentParser()
    scanner = parser.add_argument_group('Scanner')
    scanner.add_argument("-i",dest='ip', help="target host ip address")
    scanner.add_argument("-p", dest='port', help="target address ssh port")
    scanner.add_argument("-u",dest='user', help="target host ssh user")
    scanner.add_argument("-d", dest='password', help="target user ssh password")
    scanner.add_argument("-f", dest='file', help="target hosts list file name")
    arg=parser.parse_args()
    html_completer = WordCompleter(['<ssh>', '<ssl>','<nginx>', '<oracle>', '<mysql>','<docker>','<docker-ce>','<linux>','<kubernetes>','<tomcat-7>','<tomcat-8>'])
    profile = prompt('Enter Profile You Want to Scan: ', completer=html_completer)
    print('%s will be Scan'%profile)
    if arg.ip and arg.port and arg.user and arg.password:
        try:
            poc(arg.ip,int(arg.port),arg.user,arg.password,profile)
        except ConnectionRefusedError:
            print("[-] [{}] Weblogic Network Is Abnormal ".format(args.ip + ':' + str(args.port)))
            print("[*] ==========Task End==========")
    elif arg.file and profile:
        poolmana(arg.file,profile)
