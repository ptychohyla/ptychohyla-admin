from rest_framework.routers import SimpleRouter

from .views import PracticesModelViewSet

router = SimpleRouter()

router.register("api/PracticesModelViewSet", PracticesModelViewSet)

urlpatterns = [
]
urlpatterns += router.urls