<template>
	<fs-page>
		<fs-crud ref="crudRef" v-bind="crudBinding"> 
			<template #form-body-top>
				<div><font color="#4169E1" size="3">
					注意：*号代表为空
				</font></div>
			</template>
			<template #form-body-bottom>
				<!-- <el-alert type="warning" title="form-body-bottom 插槽" /> -->
					<div><font color="#4169E1" size="3">
						Cron表达式通常由几个字段组成:分别代表分钟、小时、一周中的哪一天、月份中的哪一天、年中的哪个月份、（年份可选）
						<br>
						例如(0 0 * * *)表示每天午夜0点0时执行一次任务
					</font></div>
			</template>
		</fs-crud>
	</fs-page>

</template>



<script lang="ts" setup name="crontabManage">   
// 注释编号: django-vue3-admin-index500017: 上面添加name="crontabManage"

import { ref, onMounted } from 'vue';
import { useFs } from '@fast-crud/fast-crud';
import { createCrudOptions } from './crud';

const { crudBinding, crudRef, crudExpose } = useFs({ createCrudOptions });

// 页面打开后获取列表数据
onMounted(() => {
	crudExpose.doRefresh();
});
</script>
