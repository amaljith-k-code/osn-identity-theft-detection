
from django.contrib import admin
from django.urls import path
from myapp import views

urlpatterns = [
    path('login_post/', views.login_post),
    path('login_get/', views.login_get),
    path('admin_home/',views.admin_home),
    path('AdminChangePasswordPost/',views.AdminChangePasswordPost),
    path('change_pass/',views.change_pass),
    path('cyber/',views.cyber),
    path('feed_back/',views.feed_back),
    path('send/',views.send),
    path('verify_expert/',views.verify_expert),
    path('AcceptExpert/<id>/',views.AcceptExpert),
    path('RejectExpert/<id>/',views.RejectExpert),
    path('block_user/<id>',views.block_user),
    path('unblock_user/<id>',views.unblock_user),
    path('complaint_send_reply/<id>/',views.complaint_send_reply),
    path('view_complaints/',views.view_complaints),
    path('view_user/',views.view_user),

    #####Expert#####
    path('expert_home_index/',views.expert_home_index),
    path('expert_register/',views.expert_register),
    path('expert_register_post/',views.expert_register_post),
    path('add_tips/',views.add_tips),
    path('change_pass_expert/',views.change_pass_expert),
    path('ExpertChangePasswordPost/',views.ExpertChangePasswordPost),
    path('manage_profile/',views.manage_profile),
    path('edit_profile/', views.edit_profile),

    path('manage_tips/',views.manage_tips),
    path('send_reply/<id>',views.send_reply),
    path('view_doubt/',views.view_doubt),
    path('ManageTips/',views.ManageTips),
    path('EditTip/<id>/',views.EditTip),
    path('DeleteTip/<id>/',views.DeleteTip),



    ###################### flutter ################3

    path('flutter_login/',views.flutter_login),
    path('register/',views.register),
    path('viewprofile/',views.viewprofile),
    path('update_profile/',views.update_profile),
    path('userchangepass/',views.userchangepass),
    path('send_feedback/',views.send_feedback),
    path('send_complaint/',views.send_complaint),
    path('send_comment/',views.send_comment),
    path('view_reply/',views.view_reply),
    path('view_comments/',views.view_comments),
    path('view_own_post/',views.view_own_post),
    path('view_request/',views.view_request),

    path('search_users/', views.search_users),
    path('send_friend_request/', views.send_friend_request),
    path('view_incoming_requests/', views.view_incoming_requests),
    path('view_sent_requests/', views.view_sent_requests),
    path('manage_request/', views.manage_request),
    path('view_my_friends/', views.view_my_friends),
    path('add_post/',views.add_post),
    path('view_others_post/',views.view_others_post),
    path('Delete_cmt/',views.Delete_cmt),
    path('send_comment_reply/',views.send_comment_reply),
    path('view_comments_reply/',views.view_comments_reply),
    path('toggle_like/',views.toggle_like),
    path('toggle_likee/',views.toggle_likee),

    path('chat_api/',views.chat_api),
    path('Delete_post/',views.Delete_post),
    path('user_view_notification/',views.user_view_notification),
    path('user_accept_notification/',views.user_accept_notification),
    path('View_experts/',views.View_experts),
    path('View_experts_doubts_reply/',views.View_experts_doubts_reply),
    path('View_experts_tips/',views.View_experts_tips),
    path('send_doubt_expert/',views.send_doubt_expert),
    path('View_complaint_reply/',views.View_complaint_reply),
    path('forgot_password_post/',views.forgot_password_post),
    path('Delete_bulling_comment/<id>',views.Delete_bulling_comment),
path('user_reject_notification/',views.user_reject_notification),



]
