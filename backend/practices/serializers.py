
from practices.models import PracticeModel
from dvadmin.utils.serializers import CustomModelSerializer


class PracticeModelSerializer(CustomModelSerializer):
    """
    序列化器
    """
#这里是进行了序列化模型及所有的字段
    class Meta:
        model = PracticeModel
        fields = "__all__"

#这里是创建/更新时的列化器
class PracticeModelCreateUpdateSerializer(CustomModelSerializer):
    """
    创建/更新时的列化器
    """
    class Meta:
        model = PracticeModel
        fields = '__all__'