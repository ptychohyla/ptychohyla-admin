from practice.paper.models import paperModel

from dvadmin.utils.serializers import CustomModelSerializer


class PaperModelSerializer(CustomModelSerializer):
    """
    paper Model Serializer
    """
    class Meta:
        model = paperModel
        fields = "__all__"

class PaperModelCreateUpdateSerializer(CustomModelSerializer):
    """
    insert/update paper Model Serializer
    """
    class Meta:
        model = paperModel
        fields = "__all__"