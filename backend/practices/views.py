from django.shortcuts import render

from practices.models import PracticeModel
from practices.serializers import PracticeModelSerializer, PracticeModelCreateUpdateSerializer
from dvadmin.utils.viewset import CustomModelViewSet


class PracticesModelViewSet(CustomModelViewSet):
    """
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = PracticeModel.objects.all()
    serializer_class = PracticeModelSerializer
    create_serializer_class = PracticeModelCreateUpdateSerializer
    update_serializer_class = PracticeModelCreateUpdateSerializer