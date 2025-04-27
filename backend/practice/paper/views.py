from django.shortcuts import render

# Create your views here.
# Create your views here.
from .models import paperModel
from .serializers import PaperModelSerializer, PaperModelCreateUpdateSerializer
from dvadmin.utils.viewset import CustomModelViewSet


class PaperModelViewSet(CustomModelViewSet):
    """
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = paperModel.objects.all()
    serializer_class = PaperModelSerializer
    create_serializer_class = PaperModelCreateUpdateSerializer
    update_serializer_class = PaperModelCreateUpdateSerializer