# CT图像处理

> 作者：赵文亮
>
> 班级：自64
>
> 学号：2016011452
>

## 运行环境

- Windows 10 x64
- MATLAB R2018b
- GUI由MATLAB App designer 编写

## 运行方式

### 打开程序

- 在`app`文件夹下，双击`CT_Process.mlapp`
- 或者在MATLAB中，切换到`app`目录下，命令行中输入`CT_Process`
- 程序初始界面为`待处理图像`标签页

### 图像处理流程

#### 脊柱去除

- 切换到`脊柱去除`标签页


- 可以修改**滤波半径、亮度调整(Gamma校正)参数**
- 实时查看脊柱去除效果

#### 固定装置去除

- 切换到`固定装置去除`标签页


- 查看固定装置检测于去除结果

#### 处理结果查看

- 切换到`处理后图像`标签页
- 对比处理前后的图像

## 目录结构

- src/：源代码

- dataset/：输入图像

- results/：处理结果

  - remove_spine.jpg: 去除脊柱后的结果
  - remove_fixers.jpg：去除固定装置后的结果（即最终结果）

  > 该结果对应的参数为：
  >
  > - 滤波半径$D_0=15$
  > - Gamma校正$a = 1.1, \gamma = 0.7$，校正公式为$I'=aI^\gamma$
  >
  > 用户可以在图形界面中修改以上参数以获得更加满足自己喜好的结果。

- app/：图形界面文件`CT_Process.mlapp`

- report.pdf：报告

- README.md：说明文档