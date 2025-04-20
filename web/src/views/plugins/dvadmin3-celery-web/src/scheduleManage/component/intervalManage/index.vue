<template>
	<fs-page>
		<fs-crud ref="crudRef" v-bind="crudBinding"> 
			<template #form-body-top>
				<div><font color="#4169E1" size="3">
					基于固定的时间间隔来安排任务的执行
				</font></div>
			</template>
			<template #form-body-bottom>
				<!-- <el-alert type="warning" title="form-body-bottom 插槽" /> -->
					<div><font color="#4169E1" size="3">
						例如(every:1, period:Hours)表示每1小时执行一次
					</font></div>
			</template>
		</fs-crud>
	</fs-page>
</template>

<script lang="ts" setup name="intervalManage">
// 注释编号:django-vue3-admin-index140217:上面添加name="intervalManage"
import { ref, onMounted } from 'vue';
import { useFs } from '@fast-crud/fast-crud';
import { createCrudOptions } from './crud';

const { crudBinding, crudRef, crudExpose } = useFs({ createCrudOptions });

// 页面打开后获取列表数据
onMounted(() => {
	crudExpose.doRefresh();
});
</script>
