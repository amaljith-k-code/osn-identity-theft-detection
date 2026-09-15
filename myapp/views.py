import random
from datetime import datetime

import subprocess
from django.contrib import messages
from django.contrib.auth import authenticate, login, update_session_auth_hash
from django.contrib.auth.hashers import make_password, check_password
from django.core.files.storage import FileSystemStorage
from django.core.mail import send_mail
from django.shortcuts import render, redirect
from django.contrib.auth.models import User, Group

# Create your views here.
from myapp.encode_faces import enf
from myapp.models import *

import cv2
import os

# frpredictfnom myapp.predict_fn import
from myapp.recognize_face import rec_face_image
from osm import settings


def login_get(request):
    return render(request,"login.html")

def login_post(request):
    username=request.POST['username']
    password=request.POST['password']
    ob=authenticate(request,username=username,password=password)
    print(ob,"sarang")
    if ob is not None:
        if ob.groups.filter(name="admin").exists():
            login(request,ob)
            print(request.user.id)
            return redirect('/myapp/admin_home/')
        elif ob.groups.filter(name='expert').exists():
            e=expert.objects.get(LOGIN__id=ob.id)
            if e.status == 'Accepted':
                login(request,ob)
                print(request.user.id)
                return redirect('/myapp/expert_home_index/')
            else:
                return redirect('/myapp/login_get/')

        else:
            return redirect('/myapp/login_get/')
    else:
        return redirect('/myapp/login_get/')





def admin_home(request):
    return render(request,"admin/admin_home_index.html")


def change_pass(request):
    return render(request,"admin/changepass.html")

def AdminChangePasswordPost(request):
    current_password=request.POST['current_password']
    new_password=request.POST['new_password']
    user=request.user
    if not user.check_password(current_password):
        messages.warning(request,'Current Password Incorrect')
        return redirect('/myapp/change_pass/')
    user.set_password(new_password)
    user.save()
    update_session_auth_hash(request,user)
    messages.success(request,'Password Changed Succesfully! Log in')
    return redirect('/myapp/login_get/')


def cyber(request):
    data=commenttable.objects.filter(type="Bullying")
    return render(request,"admin/cyber.html",{"data":data})

# def feed_back(request):
#     data=feedbacktable.objects.all()
#     return render(request,"admin/feedback.html",{"data":data})

from django.db.models import Q

def feed_back(request):
    query = request.GET.get('q')
    if query:
        data = feedbacktable.objects.filter(
            Q(feedback__icontains=query) |
            Q(USER__name__icontains=query) |
            Q(USER__email__icontains=query)
        )
    else:
        data = feedbacktable.objects.all()
    return render(request, "admin/feedback.html", {"data": data})

def send(request):
    return render(request,"admin/send.html")

def verify_expert(request):
    ob=expert.objects.all()
    return render(request,"admin/Verify Expert.html",{'data':ob})

def AcceptExpert(request,id):
    ob=expert.objects.get(id=id)
    ob.status='Accepted'
    ob.save()
    return redirect('/myapp/verify_expert/')

def RejectExpert(request,id):
    ob=expert.objects.get(id=id)
    ob.status='Rejected'
    ob.save()
    return redirect('/myapp/verify_expert/')



def block_user(request,id):
    ob=usertable.objects.get(id=id)
    ob.status='block'
    ob.save()
    return redirect('/myapp/view_user/')

def unblock_user(request,id):
    ob=usertable.objects.get(id=id)
    ob.status='active'
    ob.save()
    return redirect('/myapp/view_user/')


def view_complaints(request):
    data=complainttable.objects.all()
    pending=complainttable.objects.filter(reply='pending').count()
    resolved=complainttable.objects.exclude(reply='pending').count()
    all=complainttable.objects.all().count()
    return render(request,"admin/View Complaints.html",{"data":data ,'res':resolved,'pending':pending,'all':all})

def view_user(request):
    data=usertable.objects.all()
    return render(request,"admin/viewuser.html",{"data":data})



####################expert###############
def expert_home_index(request):
    return render(request,"Expert/expert home.html")

def expert_register(request):
    return render(request,'Expert/register.html')

def expert_register_post(request):
    name=request.POST['name']
    email=request.POST['email']
    phone=request.POST['phone']
    DOB=request.POST['DOB']
    gender=request.POST['gender']
    photo=request.FILES['photo']
    place=request.POST['place']
    username=request.POST['username']
    password=request.POST['password']
    if User.objects.filter(username=username).exists():
        messages.warning(request,'Username Taken!!')
        return redirect('/myapp/expert_register/')
    user=User.objects.create(username=username,password=make_password(password))
    user.save()
    user.groups.add(Group.objects.get(name='expert'))

    ob=expert()
    ob.name=name
    ob.email=email
    ob.phone=phone
    ob.DOB=DOB
    ob.gender=gender
    ob.photo=photo
    ob.place=place
    ob.status='pending'
    ob.LOGIN=user
    ob.save()
    return redirect('/myapp/login_get')

def add_tips(request):
    return render(request,"Expert/Add tips.html")
# def add_tips_post(request):




def manage_profile(request):
    ob=expert.objects.get(LOGIN=request.user)
    return render(request,"Expert/Manage profile.html",{'data':ob})
def edit_profile(request):
    name = request.POST['name']
    email = request.POST['email']
    phone = request.POST['phone']
    DOB = request.POST['DOB']
    gender = request.POST['gender']
    place = request.POST['place']

    ob=expert.objects.get(LOGIN=request.user)
    ob.name = name
    ob.email = email
    ob.phone = phone
    ob.DOB = DOB
    ob.gender = gender
    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        ob.photo = photo
        ob.save()


    ob.place = place
    ob.save()
    return redirect('/myapp/manage_profile/')


def manage_tips(request):
    return render(request,"Expert/Manage tips.html")

def send_reply(request,id):
    if request.method == "POST":
        reply=request.POST['reply']
        DoubtTable.objects.filter(id=id).update(reply=reply)
        return redirect('/myapp/view_doubt/')
    return render(request,"Expert/send reply.html")




def complaint_send_reply(request,id):
    data=complainttable.objects.get(id=id)

    if request.method == "POST":
        reply=request.POST['reply']
        complainttable.objects.filter(id=id).update(reply=reply,status="replied")
        return redirect('/myapp/view_complaints/')
    return render(request,"admin/send.html",{"data":data})


def view_doubt(request):
    data=DoubtTable.objects.filter()
    return render(request,"Expert/view doubt.html",{"data":data})


def ManageTips(request):
    if request.method=='POST':
        tip=request.POST['tip']
        details=request.POST['details']
        ob=TipsTable()
        ob.tip=tip
        ob.details=details
        ob.EXPERT=expert.objects.get(LOGIN=request.user)
        ob.date=datetime.today()
        ob.save()
        return redirect('/myapp/ManageTips/')
    ob=TipsTable.objects.filter(EXPERT__LOGIN__id=request.user.id)
    return render(request,'Expert/Manage tips.html',{'data':ob})

def EditTip(request,id):
    tip = request.POST['tip']
    details = request.POST['details']
    ob = TipsTable.objects.get(id=id)
    ob.tip = tip
    ob.details = details
    ob.date = datetime.today()
    ob.save()
    return redirect('/myapp/ManageTips/')

def DeleteTip(request,id):
    TipsTable.objects.get(id=id).delete()
    return redirect('/myapp/ManageTips/')


def change_pass_expert(request):
    return render(request,"Expert/Changepassword.html")

def ExpertChangePasswordPost(request):
    current_password=request.POST['current_password']
    new_password=request.POST['new_password']
    user=request.user
    if not user.check_password(current_password):
        messages.warning(request,'Current Password Incorrect')
        return redirect('/myapp/change_pass_expert/')
    user.set_password(new_password)
    user.save()
    update_session_auth_hash(request,user)
    messages.success(request,'Password Changed Succesfully! Log in')
    return redirect('/myapp/login_get/')


from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import posttable, usertable
from datetime import date

# def create_post(request):
#     if request.method == 'POST':
#         try:
#             user_id = request.POST.get('user_id')
#             description = request.POST.get('description')
#             caption = request.POST.get('caption')
#             image = request.FILES.get('image')
#
#             if not user_id:
#                 return JsonResponse({'error': 'user_id required'}, status=400)
#
#             user = usertable.objects.get(id=user_id)
#
#             post = posttable.objects.create(
#                 USER=user,
#                 description=description,
#                 caption=caption,
#                 image=image,
#                 date=date.today()
#             )
#
#             return JsonResponse({
#                 'status': 'success',
#                 'post_id': post.id,
#                 'user': user.id,
#                 'caption': post.caption,
#                 'description': post.description,
#                 'date': post.date
#             }, status=201)
#
#         except usertable.DoesNotExist:
#             return JsonResponse({'error': 'User not found'}, status=404)
#
#         except Exception as e:
#             return JsonResponse({'error': str(e)}, status=500)
#
#     return JsonResponse({'error': 'Invalid request method'}, status=405)


#################flutter#################

# def flutter_login(request):
#     username=request.POST['username']
#     print(username)
#     password=request.POST['password']
#     print(password)
#     u=authenticate(request,username=username,password=password)
#     print(u)
#     if u is not None:
#         if u.groups.filter(name='user').exists():
#             prof=usertable.objects.get(LOGIN=u)
#             print('1111111111')
#             login(request,u)
#             return JsonResponse({"status":"ok","lid":request.user.id , 'image':prof.photo.url, 'name':prof.name , 'email':prof.email})
#     else:
#         return JsonResponse({"status":"no"})
#     print('errrrrrrr')
#     return JsonResponse({"status":"no"})


from django.contrib.auth import authenticate, login
from django.http import JsonResponse


def flutter_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        # 1. Authenticate with Django Built-in Auth
        u = authenticate(request, username=username, password=password)

        if u is not None:
            # 2. Check if the user belongs to the correct group
            if u.groups.filter(name='user').exists():
                try:
                    # 3. Fetch the linked usertable profile
                    prof = usertable.objects.get(LOGIN=u)

                    # 4. CHECK IF THE STATUS IS ACTIVE
                    if prof.status.lower() == "active":
                        login(request, u)
                        # Return lid (User ID), and profile details
                        return JsonResponse({
                            "status": "ok",
                            "lid": u.id,
                            "image": prof.photo.url,
                            "name": prof.name,
                            "email": prof.email
                        })
                    else:
                        # User exists but is blocked/inactive
                        return JsonResponse({"status": "blocked", "msg": "Account is inactive"})

                except usertable.DoesNotExist:
                    return JsonResponse({"status": "no", "msg": "Profile not found"})

        # Default failure response (Wrong credentials or group)
        return JsonResponse({"status": "no", "msg": "Invalid username or password"})

    return JsonResponse({"status": "no", "msg": "Invalid request method"})

def register(request):
    name=request.POST['name']
    email=request.POST['email']
    phone=request.POST['phone']
    DOB=request.POST['DOB']
    gender=request.POST['gender']
    photo=request.FILES['photo']
    username=request.POST['username']
    password=request.POST['password']

    fs = FileSystemStorage()
    path = fs.save(photo.name, photo)

    if User.objects.filter(username=username).exists():
        return JsonResponse({'msg':'username already exists'})

    user=User.objects.create(username=username,password=make_password(password))
    user.save()
    user.groups.add(Group.objects.get(name='user'))


    ob=usertable()
    ob.name=name
    ob.email=email
    ob.phone=phone
    ob.DOB=DOB
    ob.gender=gender
    ob.photo=photo
    # ob.status='pending'
    ob.LOGIN=user
    ob.save()


    enf([ob.id,path])

    return JsonResponse({"status": "ok"})

def viewprofile(request):
    lid=request.POST['lid']
    ob=usertable.objects.get(LOGIN__id=lid)
    return JsonResponse({
        "status":"ok",
        "name":ob.name,
        "email":ob.email,
        "phone":ob.phone,
        "DOB":ob.DOB,
        "gender":ob.gender,
        "photo":request.build_absolute_uri(ob.photo.url)
    })


def update_profile(request):
    name=request.POST['name']
    email=request.POST['email']
    phone=request.POST['phone']
    DOB=request.POST['DOB']
    gender=request.POST['gender']
    lid=request.POST['lid']

    fs = FileSystemStorage()

    ob=usertable.objects.get(LOGIN_id=lid)
    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        path = fs.save(photo.name, photo)
        ob.photo = photo
        ob.save()
        enf([ob.id, path])

    ob.name=name
    ob.email=email
    ob.phone=phone
    ob.DOB=DOB
    ob.gender=gender
    ob.status='pending'
    ob.save()
    return JsonResponse({"status": "ok"})

def userchangepass(request):
    oldpassword=request.POST['oldpassword']
    newpassword=request.POST['newpassword']
    confirmpassword=request.POST['newpassword']
    lid=request.POST['lid']
    print(oldpassword,newpassword,confirmpassword,lid)
    p=User.objects.get(id=lid).password
    print(request.user)
    f=check_password(oldpassword,p)
    if f:
        user=User.objects.get(id=id)
        user.set_password(newpassword)
        user.save()
        return JsonResponse({'status':'ok'})

    else:
        return JsonResponse({'status':'ok'})

def send_feedback(request):
    lid=request.POST['lid']
    feedback=request.POST['feedback']
    rating=request.POST['rating']

    a=feedbacktable()

    a.feedback=feedback
    a.Date=datetime.now()
    a.rating=rating
    a.USER=usertable.objects.get(LOGIN_id=lid)
    a.save()
    return JsonResponse({"status": "ok"})





# def send_comment(request):
#     lid=request.POST['lid']
#     pid=request.POST['pid']
#     comment=request.POST['comment']
#     a=commenttable()
#
#     a.comment=comment
#     a.date=datetime.now()
#     a.post= posttable.objects.get(id=pid)
#     a.USER = usertable.objects.get(LOGIN_id=lid)
#     a.type="Normal"
#     a.save()
#     return JsonResponse({"status":"ok"})


import re  # Add Regex for better matching


def send_comment(request):
    lid = request.POST['lid']
    pid = request.POST['pid']
    comment_text = request.POST['comment']

    comment_type = "Normal"
    csv_path = os.path.join(settings.BASE_DIR, 'bullying_keywords.csv')


    with open(csv_path, mode='r', encoding='utf-8') as file:
        # Load keywords into a list for faster lookup
        import csv
        reader = csv.DictReader(file)
        keywords = [row['keyword'].lower() for row in reader]

        # Check if any keyword matches as a whole word
        for kw in keywords:
            # \b represents a word boundary so "rat" won't match "congratulations"
            pattern = r'\b' + re.escape(kw) + r'\b'
            if re.search(pattern, comment_text.lower()):
                comment_type = "Bullying"
                break


    a = commenttable()
    a.comment = comment_text
    a.date = datetime.now()
    a.post = posttable.objects.get(id=pid)
    a.USER = usertable.objects.get(LOGIN_id=lid)
    a.type = comment_type
    a.save()

    return JsonResponse({"status": "ok", "detected": comment_type})

def view_reply(request):
    ob=complainttable.objects.all()
    print(ob,"ghgh")
    mdata=[]
    for i in ob:
        data={'Date':i.date,'complaints':i.complaints,'reply':i.reply,'status':i.status}
        mdata.append(data)
        print(mdata)

    return JsonResponse({"status": "ok","data":mdata})

def view_comments(request):
    pid=request.POST['pid']
    lid=request.POST['lid']
    print(pid,"pid")
    ob=commenttable.objects.filter(post_id=pid)
    print(ob,"ghgh")
    mdata=[]
    for i in ob:
        cc=posttable.objects.filter(USER__LOGIN_id=lid)
        if cc.exists():
            data={
                'id':i.id,
                'Date':i.date,
                # 'post':i.post.,
                'comment':i.comment,
                'type':i.type,
                'u_name':i.USER.name,
                'delete_status':True
            }
            mdata.append(data)
        else:
            data = {
                'id': i.id,
                'Date': i.date,
                # 'post':i.post.,
                'comment': i.comment,
                'type': i.type,
                'u_name': i.USER.name,
                'delete_status': False
            }
            mdata.append(data)
        print(mdata)

    return JsonResponse({"status": "ok","data":mdata})




def view_comments_reply(request):
    cid=request.POST['cid']
    lid=request.POST['lid']
    ob=commentreply.objects.filter(comment_id=cid)
    print(ob,"ghgh")
    mdata=[]
    for i in ob:
        cc=commentreply.objects.filter(USER__LOGIN_id=lid)
        if cc.exists():
            data={
                'id':i.id,
                'Date':i.date,
                # 'post':i.post.,
                'comment':i.comment,
                'type':i.type,
                'u_name':i.USER.name,
                'delete_status':True
            }
            mdata.append(data)
        else:
            data = {
                'id': i.id,
                'Date': i.date,
                # 'post':i.post.,
                'comment': i.comment,
                'type': i.type,
                'u_name': i.USER.name,
                'delete_status': False
            }
            mdata.append(data)
        print(mdata)

    return JsonResponse({"status": "ok","data":mdata})




def send_comment_reply(request):
    lid=request.POST['lid']
    cid=request.POST['cid']
    reply=request.POST['comment']
    a=commentreply()

    a.reply=reply
    a.date=datetime.now().today()
    a.time=datetime.now()
    a.comment= commenttable.objects.get(id=cid)
    a.USER = usertable.objects.get(LOGIN_id=lid)
    a.save()
    return JsonResponse({"status":"ok"})





def view_own_post(request):
    lid = request.POST['lid']
    ob=posttable.objects.filter(USER__LOGIN__id=lid)
    print(ob,"ghgh")
    mdata=[]
    for i in ob:
        total_likes = liketable.objects.filter(post=i).count()
        is_liked = liketable.objects.filter(
            post=i,
            USER__id=lid
        ).exists()

        data = {
            'post_id': i.id,   # 🔥 VERY IMPORTANT
            'username': i.USER.name,
            'Date': i.date,
            'image': i.image.url,
            'description': i.description,
            'caption': i.caption,
            'total_likes': total_likes,
            'is_liked': is_liked
        }

        mdata.append(data)

    return JsonResponse({"status": "ok","data":mdata})

#
# def view_others_post(request):
#     lid = request.POST['lid']
#     ob=posttable.objects.exclude(USER__LOGIN__id=lid)
#     print(ob,"ghgh")
#     mdata=[]
#     for i in ob:
#         data={
#             'username':i.USER.name,
#             'Date':i.date,
#             'image':i.image.url,'description':i.description,'caption':i.caption}
#         mdata.append(data)
#         print(mdata)
#
#     return JsonResponse({"status": "ok","data":mdata})




# def view_others_post(request):
#     lid = request.POST['lid']
#     ob = posttable.objects.exclude(USER__LOGIN__id=lid)
#
#     mdata = []
#
#     for i in ob:
#
#         userids=i.USER.id
#
#         friend=requesttable.objects.filter(Q(fromuser__LOGIN_id=lid,touser_id=i.USER.LOGIN.id)|Q(fromuser__LOGIN_id=lid,touser_id=i.USER.LOGIN.id),status="accepted")
#
#         if friend:
#             total_likes = liketable.objects.filter(post=i).count()
#             is_liked = liketable.objects.filter(
#                 post=i,
#                 USER__id=lid
#             ).exists()
#
#             data = {
#                 'post_id': i.id,   # 🔥 VERY IMPORTANT
#                 'username': i.USER.name,
#                 'Date': i.date,
#                 'image': i.image.url,
#                 'description': i.description,
#                 'caption': i.caption,
#                 'total_likes': total_likes,
#                 'is_liked': is_liked
#             }
#
#             mdata.append(data)
#
#             return JsonResponse({"status": "ok", "data": mdata})



def view_request(request):
    ob=requesttable.objects.all()
    print(ob,"ghgh")
    mdata=[]
    for i in ob:
        data={'Date':i.date,'status':i.status,'fromuser':i.fromuser.name,'touser':i.touser.name}
        mdata.append(data)
        print(mdata)

    return JsonResponse({"status": "ok","data":mdata})


from django.http import JsonResponse
from .models import *
from django.db.models import Q
from django.utils import timezone


# 1. VIEW ALL USERS (EXCEPT SELF & ALREADY REQUESTED)
def search_users(request):
    lid = request.POST['lid']
    # Get current user's profile
    me = usertable.objects.get(LOGIN_id=lid)

    # Get IDs of people I have already sent requests to
    sent_requests = requesttable.objects.filter(fromuser=me).values_list('touser_id', flat=True)

    # Get IDs of people who sent requests to me
    received_requests = requesttable.objects.filter(touser=me.LOGIN).values_list('fromuser__LOGIN_id', flat=True)

    # Exclude: myself, people I requested, and people who requested me
    users = usertable.objects.exclude(LOGIN_id=lid).exclude(LOGIN_id__in=sent_requests).exclude(
        LOGIN_id__in=received_requests)

    user_list = []
    for u in users:
        user_list.append({
            "to_id": u.LOGIN.id,  # This is the ID for touser
            "name": u.name,
            "photo": u.photo.url
        })
    return JsonResponse({"status": "ok", "users": user_list})


# 2. SEND FRIEND REQUEST
def send_friend_request(request):
    from_lid = request.POST['lid']
    to_lid = request.POST['to_lid']

    from_prof = usertable.objects.get(LOGIN_id=from_lid)
    to_user_obj = User.objects.get(id=to_lid)

    # Double check if request already exists (prevent duplicates)
    exists = requesttable.objects.filter(fromuser=from_prof, touser=to_user_obj).exists()

    if not exists:
        obj = requesttable()
        obj.fromuser = from_prof
        obj.touser = to_user_obj
        obj.Date = timezone.now().date()
        obj.status = 'pending'
        obj.save()
        return JsonResponse({"status": "ok"})
    else:
        return JsonResponse({"status": "already_exists"})


# 3. VIEW INCOMING REQUESTS
def view_incoming_requests(request):
    lid = request.POST['lid']
    # Filter by touser (which is the User model)
    reqs = requesttable.objects.filter(touser_id=lid, status='pending')

    data = []
    for r in reqs:
        data.append({
            "rid": r.id,
            "name": r.fromuser.name,
            "photo": request.build_absolute_uri(r.fromuser.photo.url),
            "date": str(r.Date)
        })
    return JsonResponse({"status": "ok", "data": data})


# 4. VIEW SENT REQUEST STATUS
def view_sent_requests(request):
    lid = request.POST['lid']
    me = usertable.objects.get(LOGIN_id=lid)
    reqs = requesttable.objects.filter(fromuser=me)

    data = []
    for r in reqs:
        # Since 'touser' is a User object, we find the corresponding 'usertable' entry to get the name
        receiver_profile = usertable.objects.get(LOGIN=r.touser)
        data.append({
            "name": receiver_profile.name,
            "status": r.status,
            "date": str(r.Date)
        })
    return JsonResponse({"status": "ok", "data": data})


# 5. ACCEPT OR REJECT
def manage_request(request):
    rid = request.POST['rid']
    status_choice = request.POST['status']  # 'accepted' or 'rejected'

    req = requesttable.objects.get(id=rid)
    if status_choice == 'accepted':
        req.status = 'accepted'
        req.save()
    else:
        req.delete()  # Rejects by removing the entry

    return JsonResponse({"status": "ok"})



# def view_my_friends(request):
#     lid = request.POST['lid']
#     me = usertable.objects.get(LOGIN_id=lid)
#
#     # Friends where I am sender OR I am receiver
#     friends_as_sender = requesttable.objects.filter(fromuser=me, status='accepted')
#     friends_as_receiver = requesttable.objects.filter(touser=me.LOGIN, status='accepted')
#
#     friend_list = []
#
#     for f in friends_as_sender:
#         prof = usertable.objects.get(LOGIN=f.touser)
#         friend_list.append({"name": prof.name, "photo": request.build_absolute_uri(prof.photo.url)})
#
#     for f in friends_as_receiver:
#         friend_list.append({"name": f.fromuser.name, "photo": request.build_absolute_uri(f.fromuser.photo.url)})
#
#     return JsonResponse({"status": "ok", "data": friend_list})


from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .models import usertable, requesttable

@csrf_exempt
def view_my_friends(request):
    # Support POST only
    if request.method != 'POST':
        return JsonResponse({"status": "error", "message": "POST request required"})

    try:
        # Try parsing JSON first
        try:
            data = json.loads(request.body)
            lid = data.get('lid')
        except:
            # fallback to form-encoded
            lid = request.POST.get('lid')

        if not lid:
            return JsonResponse({"status": "error", "message": "lid not provided"})

        me = usertable.objects.get(LOGIN_id=lid)

        # Friends where I am sender OR receiver
        friends_as_sender = requesttable.objects.filter(fromuser=me, status='accepted')
        friends_as_receiver = requesttable.objects.filter(touser=me.LOGIN, status='accepted')

        friend_list = []

        # Friends where I am the sender
        for f in friends_as_sender:
            prof = usertable.objects.get(LOGIN=f.touser)
            friend_list.append({
                "id": prof.LOGIN_id,
                "name": prof.name,
                "photo": request.build_absolute_uri(prof.photo.url) if prof.photo else ""
            })

        # Friends where I am the receiver
        for f in friends_as_receiver:
            friend_list.append({
                "id": f.fromuser.LOGIN_id,
                "name": f.fromuser.name,
                "photo": request.build_absolute_uri(f.fromuser.photo.url) if f.fromuser.photo else ""
            })

        return JsonResponse({"status": "ok", "data": friend_list})

    except usertable.DoesNotExist:
        return JsonResponse({"status": "error", "message": "User not found"})
    except Exception as e:
        return JsonResponse({"status": "error", "message": str(e)})




# def add_post(request):
#     description=request.POST['description']
#     caption=request.POST['caption']
#     photo=request.FILES['photo']
#     lid=request.POST['lid']
#
#
#
#
#
#     ob=posttable()
#     ob.caption=caption
#     ob.description=description
#     ob.image=photo
#     ob.USER=usertable.objects.get(LOGIN_id=lid)
#     ob.date = timezone.now().date()
#     ob.save()
#
#
#
#
#     return JsonResponse({"status": "ok"})

def Delete_cmt(request):
    cid=request.POST['cid']
    commenttable.objects.filter(id=cid).delete()
    return JsonResponse({"status": "ok"})

def Delete_post(request):
    pid=request.POST['pid']
    posttable.objects.filter(id=pid).delete()
    return JsonResponse({"status": "ok"})

def Delete_bulling_comment(request,id):
    commenttable.objects.filter(id=id).delete()
    return redirect('/myapp/cyber/')



from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .models import liketable, usertable, posttable


def toggle_like(request):
    if request.method == "POST":
        data = json.loads(request.body)

        user_id = data.get("user_id")
        post_id = data.get("post_id")

        print(user_id,post_id)

        user = usertable.objects.get(LOGIN_id=user_id)
        post = posttable.objects.get(id=post_id)

        like = liketable.objects.filter(USER=user, post=post).first()

        if like:
            like.delete()
            status = "unliked"
        else:
            liketable.objects.create(
                USER=user,
                post=post,
                like_dislike="like",
                date=datetime.today()
            )
            status = "liked"

        # 🔥 Count total likes
        total_likes = liketable.objects.filter(post=post).count()

        return JsonResponse({
            "status": status,
            "total_likes": total_likes
        })




def get_like_count(request, post_id):
    post = posttable.objects.get(id=post_id)
    total_likes = liketable.objects.filter(post=post).count()

    return JsonResponse({
        "total_likes": total_likes
    })






def view_others_post(request):
    lid = request.POST['lid']
    # Exclude own posts
    ob = posttable.objects.exclude(USER__LOGIN__id=lid)
    mdata = []

    for i in ob:
        # Check if they are friends (Accepted status)
        friend = requesttable.objects.filter(
            Q(fromuser__LOGIN__id=lid, touser_id=i.USER.LOGIN.id) |
            Q(fromuser__LOGIN__id=i.USER.LOGIN.id, touser_id=lid),
            status="accepted"
        ).exists()

        if friend:
            total_likes = liketable.objects.filter(post=i).count()
            is_liked = liketable.objects.filter(post=i, USER__LOGIN__id=lid).exists()

            mdata.append({
                'post_id': i.id,
                'username': i.USER.name,
                'Date': i.date,
                # "image": request.build_absolute_uri(i.image.url),
                "image": i.image.url,
                'description': i.description,
                'caption': i.caption,
                'total_likes': total_likes,
                'is_liked': is_liked
            })

    return JsonResponse({"status": "ok", "data": mdata})  # Move this OUTSIDE the loop




@csrf_exempt
def toggle_likee(request):
    if request.method == "POST":
        data = json.loads(request.body)

        user_id = data.get("user_id")
        post_id = data.get("post_id")

        print("Received:", user_id, post_id)

        if not user_id or not post_id:
            return JsonResponse({
                "status": "error",
                "message": "Missing user_id or post_id"
            })

        user = usertable.objects.filter(LOGIN_id=user_id).first()
        post = posttable.objects.filter(id=post_id).first()

        if not user or not post:
            return JsonResponse({
                "status": "error",
                "message": "User or Post not found"
            })

        like = liketable.objects.filter(USER=user, post=post).first()

        if like:
            like.delete()
            status = "unliked"
        else:
            liketable.objects.create(
                USER=user,
                post=post,
                like_dislike="like",
                date=timezone.now().date()
            )
            status = "liked"

        total_likes = liketable.objects.filter(post=post).count()

        return JsonResponse({
            "status": status,
            "total_likes": total_likes
        })

    return JsonResponse({"status": "error"})



def chat_api(request):

    if request.method == 'POST':

        # 1. SEND MESSAGE LOGIC

        if 'message' in request.POST:

            sid = request.POST.get('sender_id')

            rid = request.POST.get('receiver_id')

            msg = request.POST.get('message')

            ChatTable.objects.create(

                SENDER_id=sid,

                RECEIVER_id=rid,

                message=msg

            )
            return JsonResponse({'status': 'ok'})
        # 2. VIEW MESSAGE LOGIC
        else:

            sid = request.POST.get('sender_id')

            rid = request.POST.get('receiver_id')

            chats = ChatTable.objects.filter(

                (Q(SENDER_id=sid) & Q(RECEIVER_id=rid)) |

                (Q(SENDER_id=rid) & Q(RECEIVER_id=sid))

            ).order_by('date', 'time')

            # Update unread messages

            chats.filter(RECEIVER_id=sid).update(is_read=True)

            data = [{

                'sid': str(c.SENDER.id),

                'msg': c.message,

                'time': c.time.strftime("%I:%M %p")

            } for c in chats]

            return JsonResponse({'status': 'ok', 'data': data})

    return JsonResponse({'status': 'error'})




face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

def add_post(request):
    lid=request.POST['lid']
    caption=request.POST['caption']
    description=request.POST['description']
    image=request.FILES['photo']


    fs=FileSystemStorage()
    path=fs.save(image.name,image)
    ob=usertable.objects.get(LOGIN__id=lid)
    print(path)
    image = cv2.imread(r"C:\Users\ikart\Downloads\osm.awh\osm\media/" + path)
    cv2.imwrite(r"C:\Users\ikart\Downloads\osm.awh\osm\media/or_" + path, image)

    # hp = subprocess.run([
    #     r'C:\Users\salva\AppData\Local\Programs\Python\Python36\python.exe',
    #     r'C:\Users\salva\PycharmProjects\scam_reporting_system\Myapp\predict_fn.py'
    # ], input=path.encode('utf-8'))
    # res, p = predictfn(os.path.join(r"C:\Users\ikart\Downloads\osm.awh\osm\media", path))
    # print(p, "res===========")
    # if str(res) == "1":
    #     rese = "REAL"
    # else:
    #     rese = "FAKE"
    # print(res, "********************************************************************")
    # print(rese, "********************************************************************")
    if True:


        # Read the input image
        img = image
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        # Detect faces
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)

        print(f"Detected {len(faces)} face(s)")

        # Create output directory if needed
        output_dir = 'cropped_faces'
        os.makedirs(output_dir, exist_ok=True)

        var = posttable()
        var.description = description
        var.caption = caption
        var.image = path
        var.date = datetime.now().today().date()
        var.USER = usertable.objects.get(LOGIN_id=lid)
        var.status = 'Posted'
        var.save()
        # Crop and save/display faces
        for i, (x, y, w, h) in enumerate(faces):
            face = img[y:y + h, x:x + w]
            face_path = os.path.join(output_dir, f'face_{i+1}.jpg')
            cv2.imwrite(face_path, face)
            res = rec_face_image(face_path)
            for j in res:
                if str(j)!=str(ob.id):
                    blurred = cv2.blur(face, (80,80))
                    img[y:y + h, x:x + w]=blurred
                    obn=postnotification()
                    obn.USER = usertable.objects.get(id=j)
                    obn.post = var
                    obn.date = datetime.today()
                    obn.status='pending'
                    obn.save()

        fn=path
        cv2.imwrite(r"C:\Users\ikart\Downloads\osm.awh\osm\media/"+fn,img)
        return JsonResponse({"status": "ok"})
    return JsonResponse({"status": "na"})




def user_view_notification(request):
    lid = request.POST['lid']  # Get logged-in user ID from POST request
    l = []

    var = postnotification.objects.filter(USER__LOGIN_id=lid)

    for i in var:
        l.append({
            'id': i.id,
            'date': str(i.post.date),       # Convert date to string for JSON
            'description': str(i.post.description),       # Convert date to string for JSON
            'image': str(i.post.image.url[1:]),     # Convert image (likely FileField/ImageField) to string (URL/path)
            'caption': str(i.post.caption), # Convert caption to string
            'status': str(i.status), # Convert caption to string
        })
    print(l,'postttttt')

    return JsonResponse({"status": "ok", 'data': l})



def user_accept_notification(request):
    nid=request.POST['nid']
    ob=postnotification.objects.get(id=nid)
    ob.status="Accepted"
    ob.save()
    pob=ob.post
    obb=postnotification.objects.filter(post__id=pob.id,status="Accepted")
    ids=[]
    for i in obb:
        ids.append(str(i.USER.id))
    ids.append(str(pob.USER.id))
    image = cv2.imread(r"C:\Users\ikart\Downloads\osm.awh\osm\media/or_" + str(pob.image))
    # cv2.imwrite(r"C:\Users\salva\PycharmProjects\scam_reporting_system\media/or_" + path, image)

    #

    # Read the input image
    img = image
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Detect faces
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)

    print(f"Detected {len(faces)} face(s)")

    # Create output directory if needed
    output_dir = 'cropped_faces'

    # Crop and save/display faces
    for i, (x, y, w, h) in enumerate(faces):
        face = img[y:y + h, x:x + w]
        face_path = os.path.join(output_dir, f'face_{i+1}.jpg')
        cv2.imwrite(face_path, face)
        res = rec_face_image(face_path)
        for j in res:
            if str(j)not in ids:
                blurred = cv2.blur(face, (15, 15))
                img[y:y + h, x:x + w]=blurred


    fn=str(pob.image)
    cv2.imwrite(r"C:\Users\ikart\Downloads\osm.awh\osm\media/"+fn,img)


    return JsonResponse({"status": "ok"})



def user_reject_notification(request):
    nid=request.POST['nid']
    ob=postnotification.objects.get(id=nid)
    ob.status="Rejected"
    ob.save()
    return JsonResponse({"status": "ok"})




# ====================== User View Experts ================


def View_experts(request):
    # Filter by touser (which is the User model)
    reqs = expert.objects.filter(status='Accepted')

    data = []
    for r in reqs:
        data.append({
            "eid": r.id,
            "name": r.name,
            "email": r.email,
            "phone": r.phone,
            "DOB": r.DOB,
            "gender": r.gender,
            "photo": r.photo.url,
            "status": r.status,
            "place": r.place,
        })
    return JsonResponse({"status": "ok", "data": data})


def View_experts_tips(request):
    eid = request.POST['eid']
    # Filter by touser (which is the User model)
    reqs = TipsTable.objects.filter(EXPERT_id=eid,)

    data = []
    for r in reqs:
        data.append({
            "id": r.id,
            "e_name": r.EXPERT.name,
            "tip": r.tip,
            "details": r.details,
            "date": r.date,
        })
    return JsonResponse({"status": "ok", "data": data})




def send_doubt_expert(request):
    lid=request.POST['lid']
    eid=request.POST['eid']
    doubt=request.POST['doubt']

    a=DoubtTable()
    a.doubt=doubt
    a.reply="pending"
    a.date=datetime.now().today()
    a.EXPERT= expert.objects.get(id=eid)
    a.USER = usertable.objects.get(LOGIN_id=lid)
    a.save()
    return JsonResponse({"status":"ok"})


def View_experts_doubts_reply(request):
    eid = request.POST['eid']
    # Filter by touser (which is the User model)
    reqs = DoubtTable.objects.filter(EXPERT_id=eid,)

    data = []
    for r in reqs:
        data.append({
            "id": r.id,
            "e_name": r.EXPERT.name,
            "doubt": r.doubt,
            "reply": r.reply,
            "date": r.date,
        })
    return JsonResponse({"status": "ok", "data": data})





# def send_complaint(request):
#     lid=request.POST['lid']
#     doub=request.POST['doubt']
#
#     a=DoubtTable()
#     a.doubt=doubt
#     a.reply="pending"
#     a.date=datetime.now().today()
#     a.EXPERT= expert.objects.get(id=eid)
#     a.USER = usertable.objects.get(LOGIN_id=lid)
#     a.save()
#     return JsonResponse({"status":"ok"})



def  send_complaint(request):
    lid=request.POST['lid']
    complaint=request.POST['complaint']

    a=complainttable()

    a.complaints=complaint
    a.Date=datetime.now()
    a.reply='pending'
    a.status='pending'
    a.USER=usertable.objects.get(LOGIN_id=lid)
    a.save()
    return JsonResponse({"status": "ok"})


def View_complaint_reply(request):
    # Filter by touser (which is the User model)
    lid=request.POST['lid']

    reqs = complainttable.objects.filter(USER__LOGIN_id=lid)

    data = []
    for r in reqs:
        data.append({
            "id": r.id,
            "complaints": r.complaints,
            "reply": r.reply,
            "date": r.Date,
            "status": r.status,
        })
    return JsonResponse({"status": "ok", "data": data})


# ================== forgot password =============

def forgot_password_post(request):
    if request.method == "POST":
        email = request.POST.get("email")
        user = None

        # Check across all tables
        if usertable.objects.filter(email=email).exists():
            user = usertable.objects.get(email=email)
        else:
            return JsonResponse({"status": "no"})  # Redirect to login page
        if user:
            login_obj = User.objects.get(id=user.LOGIN_id)
            new_password = str(random.randint(10000000, 99999999))
            login_obj.set_password(new_password)
            login_obj.save()

            subject = "Forgot Password - Online Social Network OSN "
            body = f"Your new password is {new_password}. Please change it after login."

            send_mail(
                subject,
                body,
                'osnawh@gmail.com',  # from email
                [email],  # to email
                fail_silently=False,
            )

            print(f"Email sent successfully to {email}")
            return JsonResponse({"status": "ok"})  # Redirect to login page

        return JsonResponse({"status": "no"})  # Redirect to login page
    return JsonResponse({"status": "no"})  # Redirect to login page














