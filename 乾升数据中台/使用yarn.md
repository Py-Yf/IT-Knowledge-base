# 使用YARN

## YARN使用常用命令<br/>
1. 初始化包<br/>
	`yarn init `
2. 	安装`package.json` 文件里定义的所有依赖<br/>
	`yarn install `
3.  安装一个依赖包<br/>
	`yarn add  要装的包文件名`
4. 	全局安装<br/>
	`yarn global add 要装的包文件名 `
5. 	本地跑测试<br/>
	`yarn serve   `
6. 	编译发布文件<br/>
	`yarn build   `
7. 	从当前包里移除一个未使用的包<br/>
	`yarn remove `
8. 	发布一个包到包管理器<br/>
	`yarn publish `
	
#### 初始化新项目 <br/>
	yarn init
	
#### 添加依赖包 <br/>
	yarn add [package]
	yarn add [package]@[version]
	yarn add [package]@[tag]
	// 举例子
	yarn add less
	yarn add less@2.1.2
	yarn add less@firstjob

#### 将依赖项添加到不同依赖项类别
分别添加到 devDependencies、peerDependencies 和 optionalDependencies：<br/>

	yarn add [package] --dev
	yarn add [package] --peer
	yarn add [package] --optional
	
#### 升级依赖包

	yarn upgrade [package]
	yarn upgrade [package]@[version]
	yarn upgrade [package]@[tag]
	
#### 移除依赖包

	yarn remove [package]

#### 安装项目的全部依赖

	yarn 或  yarn install	
