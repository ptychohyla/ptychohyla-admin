from django.db import models

# Create your models here.
from dvadmin.utils.models import CoreModel

class paperModel(CoreModel):
    """
    paper Model
    """
    name = models.CharField(max_length=100, verbose_name="Name")
    total_score = models.IntegerField(verbose_name="Total Score")


    class Meta:
        db_table = 'papers'
        verbose_name = "papers table" 
        verbose_name_plural = verbose_name 
        ordering = ['-create_datetime',]  