total_count = int(raw_input())
numbers_list = []

start_list = [4,5,6]

for count in range(total_count):
    numbers_list.append(raw_input())


def val_start(num):
    if int(num[0]) in start_list:
        return True
    else:
        return False


def val_group(num):
    for val in num.split("-"):
        if len(val) != 4:
            return False

    return True


def val_len(num):
    check = num
    check2 = True
    if "-" in num:
        check = "".join(num.split("-"))
        check2 = val_group(num)

    if ((len(check) == 16) and check2):
        return True
    else:
        return False


def val_isdigit(num):
    if not num.isdigit():
        for ch in num:
            if not (ch.isdigit() | (ch == "-")):
                return False
    return True


def val_rep(num):
    res = "".join(num.split("-"))
    for i in range(len(res)):
        try:
            if (res[i] == res[i+1]):
                if (res[i+1] == res[i+2]):
                    if (res[i+2] == res[i+3]):
                        return False
        except IndexError:
           pass
    return True

for num in numbers_list:
    result = [val_start(num), val_len(num),val_isdigit(num), val_rep(num)]
    if 