## Quick Start

### 创建App

```bash
cd backend
python manage.py startapp demo
# 如果需要指定创建的目录，可以先创建目录(目录名称与需要创建的app名称同名)再执行：python manage.py startapp demo ./demo
```

### 添加到settings.py

```python
# backend/application/settings.py

INSTALLED_APPS = [
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "django_comment_migrate",
    "rest_framework",
    "django_filters",
    "corsheaders",  # 注册跨域app
    "drf_yasg",
    "captcha",
    'channels',
]

#主要添加如下代码
My_Apps = [
 'crud_demo',  #新的应用写在这里
]

INSTALLED_APPS += My_Apps
```

### 编写Models

```python
#文件backend/crud_demo/models.py

from django.db import models

# Create your models here.
from dvadmin.utils.models import CoreModel


class CrudDemoModel(CoreModel):
    goods = models.CharField(max_length=255, verbose_name="商品")
    inventory = models.IntegerField(verbose_name="库存量")
    goods_price = models.FloatField(verbose_name="商品定价")
    purchase_goods_date = models.DateField(verbose_name="进货时间")

    class Meta:
        db_table = "goods"
        verbose_name = '商品表'
        verbose_name_plural = verbose_name
        ordering = ('-create_datetime',)
```

### 新建serializers.py

```python
#backend/crud_demo/serializers.py

from crud_demo.models import CrudDemoModel
from dvadmin.utils.serializers import CustomModelSerializer


class CrudDemoModelSerializer(CustomModelSerializer):
    """
    序列化器
    """
#这里是进行了序列化模型及所有的字段
    class Meta:
        model = CrudDemoModel
        fields = "__all__"

#这里是创建/更新时的列化器
class CrudDemoModelCreateUpdateSerializer(CustomModelSerializer):
    """
    创建/更新时的列化器
    """

    class Meta:
        model = CrudDemoModel
        fields = '__all__'
```

### 编写视图views

```python
# Create your views here.
from crud_demo.models import CrudDemoModel
from crud_demo.serializers import CrudDemoModelSerializer, CrudDemoModelCreateUpdateSerializer
from dvadmin.utils.viewset import CustomModelViewSet


class CrudDemoModelViewSet(CustomModelViewSet):
    """
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = CrudDemoModel.objects.all()
    serializer_class = CrudDemoModelSerializer
    create_serializer_class = CrudDemoModelCreateUpdateSerializer
    update_serializer_class = CrudDemoModelCreateUpdateSerializer
```

### 新建urls.py并添加路由

```python
#backend/crud_demo/urls.py

from rest_framework.routers import SimpleRouter

from .views import CrudDemoModelViewSet

router = SimpleRouter()
# 这里进行注册路径，并把视图关联上，这里的api地址以视图名称为后缀，这样方便记忆api/CrudDemoModelViewSet
router.register("api/CrudDemoModelViewSet", CrudDemoModelViewSet)

urlpatterns = [
]
urlpatterns += router.urls
```

### 在application的urls里导入我们的app

```python
# backend/application/urls.py

# 就是添加如下内容，把自己的路由单独写出来，这样方便与dvadmin3的官方路由作区分
My_Urls = (
 [ #这里的crud_demo是指django创建的应用名称crud_demo
        path('',include('crud_demo.urls')),]
)

# 这里把自己的路径单独出来，后面再追加在一起
urlpatterns += My_Urls
```

### 迁移

```bash
python3 manage.py makemigrations
python3 manage.py migrate
```

### 前端目录

```bash
    views
     |--crud_demo
      |--CrudDemoModelViewSet
          |--api.ts  //定义api接口
          |--crud.tsx //配置crud界面
          |--index.vue //vue文件
```

打开web/src/views/crud_demo新建一个目录为CrudDemoModelViewSet,并新建crud.tsx,index.vue,api.ts三个文件

### api.ts： crud的api接口文件

实现添删改查请求接口，实际开发中，复制后修改apiPrefixr的值即可，你也可以在此页面根据实际业务需求增加和修改方法

```typescript
import { request,downloadFile } from '/@/utils/service';
import { PageQuery, AddReq, DelReq, EditReq, InfoReq } from '@fast-crud/fast-crud';

export const apiPrefix = '/api/CrudDemoModelViewSet/';

export function GetList(query: PageQuery) {
 return request({
  url: apiPrefix,
  method: 'get',
  params: query,
 });
}
export function GetObj(id: InfoReq) {
 return request({
  url: apiPrefix + id,
  method: 'get',
 });
}

export function AddObj(obj: AddReq) {
 return request({
  url: apiPrefix,
  method: 'post',
  data: obj,
 });
}

export function UpdateObj(obj: EditReq) {
 return request({
  url: apiPrefix + obj.id + '/',
  method: 'put',
  data: obj,
 });
}

export function DelObj(id: DelReq) {
 return request({
  url: apiPrefix + id + '/',
  method: 'delete',
  data: { id },
 });
}

export function exportData(params:any){
    return downloadFile({
        url: apiPrefix + 'export_data/',
        params: params,
        method: 'get'
    })
}
```

### index.vue： vue页面组件

```vue
<template>
 <fs-page class="PageFeatureSearchMulti">
  <fs-crud ref="crudRef" v-bind="crudBinding">
   <template #cell_url="scope">
    <el-tag size="small">{{ scope.row.url }}</el-tag>
   </template>
   <!-- 注释编号: django-vue3-admin-index442216: -->
   <!-- 注释编号:django-vue3-admin-index39263917:代码开始行-->
   <!--  功能说明:使用导入组件，并且修改api地址为当前对应的api，当前是demo的api="api/CrudDemoModelViewSet/"-->
   <template #actionbar-right>
    <importExcel api="api/CrudDemoModelViewSet/" v-auth="'user:Import'">导入</importExcel>
   </template>
   <!--  注释编号:django-vue3-admin-index263917:代码结束行-->
   
  </fs-crud>
 </fs-page>
</template>

<script lang="ts">
import { onMounted, getCurrentInstance, defineComponent} from 'vue';
import { useFs } from '@fast-crud/fast-crud';
import createCrudOptions  from './crud';

// 注释编号: django-vue3-admin-index192316:导入组件
import importExcel from '/@/components/importExcel/index.vue'   


export default defineComponent({    //这里配置defineComponent
    name: "CrudDemoModelViewSet",   //把name放在这里进行配置了
 components: {importExcel},  //注释编号: django-vue3-admin-index552416: 注册组件，把importExcel组件放在这里，这样<template></template>中才能正确的引用到组件
    setup() {   //这里配置了setup()

  const instance = getCurrentInstance();

  const context: any = {
   componentName: instance?.type.name
  };

  const { crudBinding, crudRef, crudExpose, resetCrudOptions } = useFs({ createCrudOptions, context});  


  // 页面打开后获取列表数据
  onMounted(() => {
   crudExpose.doRefresh();
  });
  return {  
  //增加了return把需要给上面<template>内调用的<fs-crud ref="crudRef" v-bind="crudBinding">
    crudBinding,
    crudRef,
   };
 

    }  //这里关闭setup()
  });  //关闭defineComponent

</script>
```

### crud.tsx： crud配置文件

```typescript
import { CrudOptions, AddReq, DelReq, EditReq, dict, CrudExpose, UserPageQuery, CreateCrudOptionsRet} from '@fast-crud/fast-crud';
import _ from 'lodash-es';
import * as api from './api';
import { request } from '/@/utils/service';
import {auth} from "/@/utils/authFunction";

//此处为crudOptions配置
export default function ({ crudExpose}: { crudExpose: CrudExpose}): CreateCrudOptionsRet {
 const pageRequest = async (query: any) => {
  return await api.GetList(query);
 };
 const editRequest = async ({ form, row }: EditReq) => {
  if (row.id) {  
   form.id = row.id;
  }
  return await api.UpdateObj(form);
 };
 const delRequest = async ({ row }: DelReq) => {
  return await api.DelObj(row.id);
 };
 const addRequest = async ({ form }: AddReq) => {
  return await api.AddObj(form);
 };

    const exportRequest = async (query: UserPageQuery) => {
  return await api.exportData(query)
 };

 return {
  crudOptions: {
   request: {
    pageRequest,
    addRequest,
    editRequest,
    delRequest,
   },
   actionbar: {
    buttons: {
      export:{
                            // 注释编号:django-vue3-admin-crud210716:注意这个auth里面的值，最好是使用index.vue文件里面的name值并加上请求动作的单词
                            show: auth('CrudDemoModelViewSet:Export'),
       text:"导出",//按钮文字
       title:"导出",//鼠标停留显示的信息
                            click(){
                                return exportRequest(crudExpose.getSearchFormData())
        // return exportRequest(crudExpose!.getSearchFormData())    // 注意这个crudExpose!.getSearchFormData()，一些低版本的环境是需要添加!的
                            }
                        },
                        add: {
                            show: auth('CrudDemoModelViewSet:Create'),
                        },
    }
   },
            rowHandle: {
                //固定右侧
                fixed: 'right',
                width: 200,
                buttons: {
                    view: {
                        type: 'text',
      order: 1,
                        show: auth('CrudDemoModelViewSet:Retrieve')
                    },
                    edit: {
                        type: 'text',
      order: 2,
      show: auth('CrudDemoModelViewSet:Update')
                    },
     copy: {
                        type: 'text',
      order: 3,
      show: auth('CrudDemoModelViewSet:Copy')
                    },
                    remove: {
                        type: 'text',
      order: 4,
      show: auth('CrudDemoModelViewSet:Delete')
                    },
                },
            },
   columns: {
    goods: {
     title: '商品',
     type: 'input',
     search: { show: true},
     column: {
      minWidth: 120,
      sortable: 'custom',
     },
     form: {
      helper: {
       render() {
        return <div style={"color:blue"}>商品是必需要填写的</div>;
        }
       },
      rules: [{ required: true, message: '商品名称必填' }],
      component: {
       placeholder: '请输入商品名称',
      },
     },
    },
                inventory: {
     title: '库存量',
     type: 'number',
     search: { show: false },
     column: {
      minWidth: 120,
      sortable: 'custom',
     },
     form: {
      rules: [{ required: true, message: '库存量必填' }],
      component: {
       placeholder: '请输入库存量',
      },
     },
    },

                goods_price: {
     title: '商品定价',
     type: 'text',
     search: { show: false },
     column: {
      minWidth: 120,
      sortable: 'custom',
     },
     form: {
      rules: [{ required: true, message: '商品定价必填' }],
      component: {
       placeholder: '请输入商品定价',
      },
     },
    },
                purchase_goods_date: {
                    title: '进货时间',
     type: 'date',
     search: { show: false },
                    form: {
                    // rules: [{ required: true, message: '进货时间必填' }],
                      component: {
                            //显示格式化
                            format: "YYYY-MM-DD",
                            //输入值格式
                            valueFormat: "YYYY-MM-DD",
                            placeholder: '请输入进货时间',
                      }
                    },
                    column: {
                      align: "center",
                      width: 120,
                      component: { name: "fs-date-format", format: "YYYY-MM-DD" }
                    }
                  },

   },
  },
 };
}
```
