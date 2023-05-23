# 为项目添加新的游戏角色

## 材料与数据准备

本项目角色所用到的数据目前有

- 角色姓名（例：黑塔）
- 角色变量名（本项目角色英文名统一与游戏官方英文名关联，如三月七变量名称应为`march7th`，黑塔角色的变量名称为`herta`）
- 角色头像照片（角色照片尽量统一采用PNG格式，宽高比为`1:1`，且大小尽量不超过`100KB`）

## 更新文件和代码

材料准备完成后，需要添加头像图像的Asset资源，同时更新项目内SRIMCharacterInfos信息。

**为项目图片资源**

以添加黑塔的人物资料为例。

首先，将准备好的角色头像文件重命名为`[角色变量名].png` (例: herta.png)

进入`star_rail_im_simulator/assets/images/srim
/avatars/`目录，将重命名后的头像文件放置到此处。

**在项目代码中添加该人物信息**

1. 进入项目目录`star_rail_im_simulator/lib/models/srim_simulator
/charactor_info.dart`，找到`SRIMCharacterInfos`类

> 注意，是`SRIMCharacterInfos`，不是`SRIMCharacterInfo`，末尾有s

2. 在此类中，添加新的static成员，其详细内容如下：

```dart
static SRIMCharacterInfo [角色变量名] = SRIMCharacterInfo(
      name: '[角色中文名]', avatarInfo: SRIMAvatarInfo(infoStr: '[角色变量名].png'));
```

例：

```dart
static SRIMCharacterInfo herta = SRIMCharacterInfo(
      name: '黑塔', avatarInfo: SRIMAvatarInfo(infoStr: 'herta.png'));
```

3. 在`SRIMCharacterInfos.list`中添加刚刚加入的新的static角色成员：

```dart
static List<SRIMCharacterInfo> list = [
    SRIMCharacterInfos.star,
    SRIMCharacterInfos.danheng,
    SRIMCharacterInfos.clara,
    SRIMCharacterInfos.himeko,
    SRIMCharacterInfos.march7th,
    SRIMCharacterInfos.welt,
    SRIMCharacterInfos.herta, // 添加本行即可
  ];
```

## 检查可用性（可选）

至此，所有添加新角色所需的代码和资源层面工作已经完成，您可以向本仓库发起新的Pull Request，并说明添加的角色。

如果您想确认添加的角色是否可以正常工作，且您的电脑有编译本项目的对应SDK环境，您可以尝试自己行编译并测试，正常情况下，新的角色信息将直接出现在消息编辑页面的角色列表中。
