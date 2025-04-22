# Ptychohyla-Admin

## 平台简介

    一套全部开源的快速开发平台，毫无保留给个人免费使用、团体授权使用。
    django-vue3-admin 基于RBAC模型的权限控制的一整套基础开发平台，权限粒度达到列级别，前后端分离，后端采用django + django-rest-framework，前端采用基于 vue3 + CompositionAPI + typescript + vite + element plus

* 🧑‍🤝‍🧑前端采用 Vue3+TS+pinia+fastcrud(感谢[vue-next-admin](https://lyt-top.gitee.io/vue-next-admin-doc-preview/))
* 👭后端采用 Python 语言 Django 框架以及强大的 [Django REST Framework](https://pypi.org/project/djangorestframework)。
* 👫权限认证使用[Django REST Framework SimpleJWT](https://pypi.org/project/djangorestframework-simplejwt)，支持多终端认证系统。
* 👬支持加载动态权限菜单，多方式轻松权限控制。
* 👬全新的列权限管控，粒度细化到每一列。

#### 🏭 环境支持

| Edge      | Firefox      | Chrome      | Safari      |
| --------- | ------------ | ----------- | ----------- |
| Edge ≥ 79 | Firefox ≥ 78 | Chrome ≥ 64 | Safari ≥ 12 |

## 在线体验

* 账号：superadmin

* 密码：admin123

## 内置功能

1. 👨‍⚕️菜单管理：配置系统菜单，操作权限，按钮权限标识、后端接口权限等。
2. 🧑‍⚕️部门管理：配置系统组织机构（公司、部门、角色）。
3. 👩‍⚕️角色管理：角色菜单权限分配、数据权限分配、设置角色按部门进行数据范围权限划分。
4. 🧑‍🎓按钮权限控制：授权角色的按钮权限和接口权限,可做到每一个接口都能授权数据范围。
5. 🧑‍🎓字段列权限控制：授权页面的字段显示权限，具体到某一列的显示权限。
7. 👨‍🎓用户管理：用户是系统操作者，该功能主要完成系统用户配置。
8. 👬接口白名单：配置不需要进行权限校验的接口。
9. 🧑‍🔧字典管理：对系统中经常使用的一些较为固定的数据进行维护。
10. 🧑‍🔧地区管理：对省市县区域进行管理。
11. 📁附件管理：对平台上所有文件、图片等进行统一管理。
12. 🗓️操作日志：系统正常操作日志记录和查询；系统异常信息日志记录和查询。

## 仓库分支说明

主分支：master（稳定版本）

## 准备工作

~~~
Python >= 3.11.0 (最低3.9+版本)
nodejs >= 16.0
Mysql >= 8.0 (可选，默认数据库sqlite3，支持5.7+，推荐8.0版本)
Redis (可选，最新版)
~~~

## 前端♝

```bash
# 克隆项目
git clone https://gitee.com/huge-dream/django-vue3-admin.git

# 进入项目目录
cd web

# 安装依赖
npm install yarn
yarn install --registry=https://registry.npmmirror.com

# 启动服务
yarn build
# 浏览器访问 http://localhost:8080
# .env.development 文件中可配置启动端口等参数
# 构建生产环境
# yarn run build
```

## 后端💈

~~~bash
1. 进入项目目录 cd backend
2. 在项目根目录中，复制 ./conf/env.example.py 文件为一份新的到 ./conf 文件夹下，并重命名为 env.py
3. 在 env.py 中配置数据库信息
 mysql数据库版本建议：8.0
 mysql数据库字符集：utf8mb4
4. 安装依赖环境
 pip3 install -r requirements.txt
5. 执行迁移命令：
 python3 manage.py makemigrations
 python3 manage.py migrate
6. 初始化数据
 python3 manage.py init
7. 初始化省市县数据:
 python3 manage.py init_area
8. 启动项目
 python3 manage.py runserver 0.0.0.0:8000
或使用 uvicorn :
  uvicorn application.asgi:application --port 8000 --host 0.0.0.0 --workers 8
~~~

### 访问项目

* 访问地址：[http://localhost:8080](http://localhost:8080) (默认为此地址，如有修改请按照配置文件)
* 账号：`superadmin` 密码：`admin123`

### docker-compose 运行

~~~shell
# 先安装docker-compose (自行百度安装),执行此命令等待安装，如有使用celery插件请打开docker-compose.yml中celery 部分注释
docker-compose up -d
# 初始化后端数据(第一次执行即可)
docker exec -ti ptychohyla-django bash
python manage.py makemigrations 
python manage.py migrate
python manage.py init_area
python manage.py init
exit

前端地址：http://127.0.0.1:8080
后端地址：http://127.0.0.1:8080/api
# 在服务器上请把127.0.0.1 换成自己公网ip
账号：superadmin 密码：admin123456

# docker-compose 停止
docker-compose down
#  docker-compose 重启
docker-compose restart
#  docker-compose 启动时重新进行 build
docker-compose up -d --build
~~~

## demo workflow

### 创建App

```bash
cd backend
python manage.py startapp demo
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

### 配置功能权限

## 演示图✅

![image-01](https://foruda.gitee.com/images/1701348994587355489/1bc749e7_5074988.png)

![image-02](https://foruda.gitee.com/images/1701349037811908960/80d361db_5074988.png)

![image-03](https://foruda.gitee.com/images/1701349224478845203/954f0a7b_5074988.png)

![image-04](https://foruda.gitee.com/images/1701349248928658877/64926724_5074988.png)

![image-05](https://foruda.gitee.com/images/1701349259068943299/1306ba40_5074988.png)

![image-06](https://foruda.gitee.com/images/1701349294894429495/e3b3a8cf_5074988.png)

![image-07](https://foruda.gitee.com/images/1701350432536247561/3b26685e_5074988.png)

![image-08](https://foruda.gitee.com/images/1701350455264771992/b364c57f_5074988.png)

![image-09](https://foruda.gitee.com/images/1701350479266000753/e4e4f7c5_5074988.png)

![image-10](https://foruda.gitee.com/images/1701350501421625746/f8dd215e_5074988.png)

## 审批流插件

![输入链接说明](https://bbs.django-vue-admin.com/uploads/20250321/97fbbf29673edfd66a1edd49237791bb.png)

![输入链接说明](https://bbs.django-vue-admin.com/uploads/20250321/c43aa51278cbc478287c718d22397479.png)

![输入链接说明](https://bbs.django-vue-admin.com/uploads/20250321/9732a5cca9c1166d1a65c35e313ab90d.png)

![输入链接说明](https://bbs.django-vue-admin.com/uploads/20250321/3ca9dd0801ce76d21435abcc8a3d505a.png)

![输入链接说明](https://bbs.django-vue-admin.com/uploads/20250321/a87a8d2329ef66880af5b0f16c5ff823.png)
