from django.db import models

from dvadmin.utils.models import CoreModel

class PracticeModel(CoreModel):
    name = models.CharField(max_length=50, verbose_name="practice name")
    total_score = models.FloatField(verbose_name="total score")
    finish_date = models.DateField(verbose_name="finish date")

    class Meta:
        db_table = "practice"
        verbose_name = 'Practice Table'
        verbose_name_plural = verbose_name 
        ordering = ('-create_datetime',)