# -*- coding: utf-8 -*-
# v2
# pip install requests beautifulsoup4 pycryptodome
import binascii
import json
import os
import uuid
from configparser import ConfigParser
from datetime import datetime, timedelta

import requests
from bs4 import BeautifulSoup
from Crypto.Cipher import DES
from Crypto.Util.Padding import pad

if not os.path.exists("config.ini"):
    with open("config.ini", "w", encoding="utf-8") as f:
        f.write("[CONFIG]\nDEBUG=False\nUSERNAME=\nPASSWORD=\n# not must\nTPNAME= \n")
        print("Please edit config.ini")
        exit()
config = ConfigParser()
config.read("config.ini", encoding="utf-8")



debug = False or os.getenv("DEBUG", config["CONFIG"]["DEBUG"])
username = "" or os.getenv("USERNAME", config["CONFIG"]["USERNAME"])
password = "" or os.getenv("PASSWORD", config["CONFIG"]["PASSWORD"])
# "https://swos.ncu.edu.cn/cs/star3/origin/" + tpName
tpName = "" or os.getenv("TPNAME", config["CONFIG"]["TPNAME"])



time = datetime.now()
loginUrl = "https://cas.ncu.edu.cn:8443/cas/login?service=https%3A%2F%2Fswos.ncu.edu.cn%2Fsfrz%2Flogin219271"
authorize = "https://swos.ncu.edu.cn/auth/connect/oauth2/authorize?appid=a8bb28edf51747e79b93bdcd57073683&redirect_uri=https%3A%2F%2Fswos.ncu.edu.cn%2Fmobile%2F%23%2Flogin%3Fredirect%3D%2FroomCheck%2Flocation%26mappId%3D8913718%26appId%3Da8bb28edf51747e79b93bdcd57073683%26appKey%3Dqpd14k0dVSEb3u1B&response_type=code&scope=snsapi_base&state=219271"
ydLoginUrl = "https://swos.ncu.edu.cn/pedestal/user/ydLogin?"
getStudentInfoUrl = (
    "https://swos.ncu.edu.cn/housemaster/sg/roomCheckPunch/getStudentInfo?cqfs=1"
)
clockInUrl = "https://swos.ncu.edu.cn/housemaster/sg/roomCheckPunch/clockIn"
getStudentRecordUrl = f"https://swos.ncu.edu.cn/housemaster/sg/roomCheckStatisticsYD/getStudentRecord?cqksrq={time.date()-timedelta(days=7)}&cqjsrq={time.date()}"

session = requests.Session()
headers = {
    "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/120.0 Mobile/15E148 Safari/605.1.15",
    "connection": "close",
}
session.headers.update(headers)


def debugLog(msg):
    if debug:
        print(f"[{datetime.now()}] [DEBUG]: {msg}")


def getToken(username, password):
    response = session.get(loginUrl)
    soup = BeautifulSoup(response.text, "html.parser")

    data = {
        "username": username,
        "password": password,
        "rememberMe": True,
        "captcha": soup.find("input", {"name": "captcha"}).get("value"),
        "currentMenu": soup.find("input", {"name": "currentMenu"}).get("value"),
        "failN": soup.find("input", {"name": "failN"}).get("value"),
        "mfaState": soup.find("input", {"name": "mfaState"}).get("value"),
        "execution": soup.find("input", {"name": "execution"}).get("value"),
        "_eventId": soup.find("input", {"name": "_eventId"}).get("value"),
        "geolocation": soup.find("input", {"name": "geolocation"}).get("value"),
        "submit": soup.find("input", {"name": "submit"}).get("value"),
    }

    session.headers.update({"Referer": loginUrl})
    response = session.post(loginUrl, data=data, allow_redirects=False)
    if response.status_code != 302:
        raise Exception("Login failed")
    session.cookies.pop("TGC")
    session.headers.update({"Referer": "https://cas.ncu.edu.cn:8443/"})

    location = response.headers.get("Location")
    debugLog(location)

    response = session.get(location, allow_redirects=False)
    location = response.headers.get("Location")
    debugLog(location)

    response = session.get(location, allow_redirects=False)
    location = response.headers.get("Location")
    debugLog(location)

    response = session.get(location, allow_redirects=False)
    location = response.headers.get("Location")
    debugLog(location)

    response = session.get(location, allow_redirects=False)
    session.headers.update({"Referer": "https://swos.ncu.edu.cn/qywx/micro/index"})

    response = session.get(authorize, allow_redirects=False)
    location = response.headers.get("Location")
    debugLog(location)

    session.headers.update({"Referer": "https://swos.ncu.edu.cn/mobile/"})
    response = session.get(ydLoginUrl + location.split("?")[1].replace("/", "%2F"))
    debugLog(response.text)

    return response.json()["data"]["token"]


def encode(plainText):
    return binascii.hexlify(
        DES.new(b"QRCODENC", DES.MODE_ECB).encrypt(
            pad((plainText).encode("utf-8"), DES.block_size)
        )
    ).decode("utf-8")


def clockIn():
    if tpName == "":
        raise Exception("tpName is empty")
    response = session.get(getStudentInfoUrl)
    debugLog(response.text)
    if not response.json()["success"]:
        raise Exception("Get student info failed")
        return
    data = response.json()["data"]
    # if data["result"]["sj"] is not None:
    #     debugLog("Already clocked in")
    #     return
    if data["batch"] is None:
        raise Exception("No batch")
        return
    batch = data["batch"]
    jsonStr = {
        "jg": "1",
        "sj": f"{time.strftime('%Y-%m-%d %H:%M:%S')}",
        "rq": f"{time.date()}",
        "pcId": batch["id"],
        "ldId": batch["ldId"],
        "cwId": batch["cwId"],
        "xsId": batch["xsId"],
        "cqfs": "1",
        "tp": {
            "name": tpName,
            "url": f"https://swos.ncu.edu.cn/cs/star3/origin/{tpName}",
            "type": "jpg",
        },
    }

    jsonStr = encode(json.dumps(jsonStr, separators=(",", ":")))
    debugLog(jsonStr)
    response = session.post(clockInUrl, headers=headers, json={"jsonStr": jsonStr})
    debugLog(response.text)
    if response.json()["success"]:
        debugLog("Clock in successfully")
    else:
        debugLog("Clock in failed!!!")


def getStudentRecord():
    response = session.get(getStudentRecordUrl)
    tp = json.loads(response.json()["data"]["list"][-2]["tp"])
    debugLog(tp)
    return tp["name"]


if __name__ == "__main__":
    debugLog(f"[{datetime.now()}][INFO]: BEGIN")
    token = getToken(username, password)
    session.headers.update({"X-Token": token})
    if tpName == "":
        tpName = getStudentRecord()
    debugLog(f"[{datetime.now()}][INFO]: tpName: {tpName}")
    clockIn()
    debugLog(f"[{datetime.now()}][INFO]: END")
