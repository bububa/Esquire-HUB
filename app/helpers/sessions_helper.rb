# encoding: UTF-8
module Authority
  Inactivated = 0
  Admin = 1
  Supervisor = 2
  EditorManager = 3
  SalesManager = 4
  Editor = 5
  Sales = 6
  Designer = 7
end

module Constants
  Authorities = ["未激活", "管理员", "Supervisor", "策划主管", "广告经理", "客户经理", "策划编辑", "美术编辑"]
  Forms = ["品牌故事", "产品介绍", "人物专访", "大片拍摄", "手绘插画", "活动报道", "特殊形式"]
  Positions = ["正刊", "读本", "别册", "特殊形式"]
  Careers = ["作者", "翻译", "摄影师", "插画师", "其他"]
  ExpenseTypes = ["稿费", "日常费用", "劳务费"]
  Sentences = ["当他们吹散一朵蒲公英的时候,  疯狂的气味, 象医院的房间和夜。", "熊说：＂你跟了我这么久，你的悲伤让我难过＂", "每个亚洲男孩的身体都是粉嫩的", "嘘[白云]", "她总是诗意的胡说，彷徨的灵魂，一分钟后窗子将会亮起，热泪盈眶的", "三杯自由古巴穿肠…身上零件儿全他妈去自由市场了", "她做着非常色情的梦，他只能一边看着色情梦，一边在她身旁手淫", "早泄、早产、早熟、产钳、脑瘫、脱钙、眩晕、呕吐、后遗症。从未做过如此的旅行，从未再这样得条件下写过一个字。", "他们生活再凡士林里，像鸬鹚一样快活", "一只被割了喉的鸡等待补血", "命运在什么地方前进，哪里就一片寂静", "多年来，他的一切，如静止的纪念碑", "二楼弹簧床上的人在努力成为一名混蛋，目前看来都很成功，他的便携武器沉甸甸的，正面、背面都是个精神失常的艺术家。另一个，腹股沟下冒着青烟。", "他们用力揉搓着对方的后脑勺，飞机被打来打去", "成为独角兽，然后为某个瞬间忘记自己", "比基尼。游泳池。橡皮坐垫。月亮代表酒鬼的心。", "海边。小镇。自行车。诊所。", "一小孩儿对着棵树撒尿，尿着尿着睡着了，鸡巴磕在了树干上！", "喝多了，就像是一架飞机，从脑人儿飞过。飞着飞着，就飞过了…[白云]", "三耳兔与小灰狼", "绝梦比绝经还糟糕，这是精神排卵的终结", "她美丽得就像白天光线在不同阶段的连续", "秘密不需要其他形式得话语就能光芒四射", "身体会因为不知身处何地而厌倦，而精神会因为不在场而亢奋", "云的愚蠢在于它总是顺风而行", "鲍伯头塑料袋指挥家", "消失具有比死亡更高的必要性，它既不是生命，也不是死亡，而是一种神秘的状态", "她的乳房平滑得就像沙漠，乳头是沙漠中矗立的两枚灯塔。她躺在面朝大海的葡萄园里，诱惑是唯一的生命强度，性欲只是一笔快乐的奖金。", "我希望明天是个晴天，咖啡厅有被光棍们扒光衣服的新娘", "他瘦弱的身躯站在圆明园远处的一方废墟上，身体细微得就像梦境血红背景上的一根神经，在啪的一声后，骤然断裂。", "一只公鸡 \ 生活在黄土高原 \ 是许多公鸡的对手 \ 众多的母鸡 \ 爱着他", "刚才一哥们儿说他在做爱的时候也实现了深圳速度…", "为了编造一个美丽的故事，你身上沾满湿漉漉的泥土，松汁，你张开嘴巴拼命呼吸，嘴里流出泥水，一个无形的泉眼，在你头发根的某个地方。而事实是她身上裹了件男士衬衫，由于近视目及有限，大步走来。我一见到她的臀部，目光便死死盯着不放，几近邪恶。", "今日，是老鼠的日子，是出海前的最后一天。太阳坠落在海滩上，烧得大海沸腾，所有的小鱼都裂开了肚子。空气中有你的头发摩擦的声音，在空中萦绕，像是鼓点", "在明晃晃的天气里, 脸上布满了树叉的阴影, 愉快地说话, 最后春天和夏天就要来临, 但二楼的长颈鹿不会变软, 看玻璃的人背过身去, 那些玻璃, 也不会被融化掉", "我的梦不过是黑夜，月光只在你的现实里映照", "他们就这样拥抱着，绕着装满苦艾酒的大盆轮流畅饮。直到春天来临，才从酒中醒来，环顾四周，经过了一整个冬季的酒醉之后，终于认出了对方。", "小葡萄胡同，走在里面心里都痒痒的。接着是小菊胡同和大菊胡同……", "徐光硕潜意识里最想做的是在荒凉的四合院里和一头大象一起执迷不悔地仰天长啸", "他们就这样拥抱着，绕着装满苦艾酒的大盆轮流畅饮。直到春天来临，才从酒中醒来，环顾四周，经过了一整个冬季的酒醉之后，终于认出了对方。"]
end

module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt] 
    current_user = user
  end
  
  def current_user=(user) 
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    current_user = nil 
  end
  
  def authenticate
    deny_access unless signed_in? 
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "请登录后访问页."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def inactivated_user?(user=nil)
    if user.nil?
      current_user.authority == Authority::Inactivated && current_user.email != 'thepeppersstudio@gmail.com'
    else
      user.authority == Authority::Inactivated && user.email != 'thepeppersstudio@gmail.com'
    end
  end
  
  def admin_user?(user=nil)
    if user.nil?
      current_user.authority == Authority::Admin || current_user.email == 'thepeppersstudio@gmail.com'
    else
      user.authority == Authority::Admin
    end
  end
  
  def supervisor_user?(user=nil)
    if user.nil?
      current_user.authority == Authority::Supervisor
    else
      user.authority == Authority::Supervisor
    end
  end
  
  def editor_manager_user?(user=nil)
    if user.nil?
      current_user.authority == Authority::EditorManager
    else
      user.authority == Authority::EditorManager
    end
  end
  
  def sales_manager_user?(user=nil)
    if user.nil?
      current_user.authority == Authority::SalesManager
    else
      user.authority == Authority::SalesManager
    end
  end
  
  def editor_user?(user=nil)
    if user.nil?
      current_user.authority == Authority::Editor
    else
      user.authority == Authority::Editor
    end
  end
  
  def sales_user?(user=nil)
    if user.nil?
      current_user.authority == Authority::Sales
    else
      user.authority == Authority::Sales
    end
  end
  
  def designer_user?(user=nil)
    if user.nil?
      current_user.authority == Authority::Designer
    else
      user.authority == Authority::Designer
    end
  end
  
  def authorized?(auth, user=nil)
    if user.nil?
      auth.include?current_user.authority
    else
      auth.include?user.authority
    end
  end
  
  def authorized(auth, user=nil)
    deny_access unless authorized?(auth, user)
  end
  
  def admin_authenticate
    deny_access unless admin_user?
  end
  
  def editor_authenticate
    deny_access unless editor_user?||admin_user?
  end
  
  def editor_manager_authenticate
    deny_access unless editor_manager_user?||admin_user?
  end
  
  def sales_or_editor_manager_authenticate
    deny_access unless editor_manager_user?||sales_user?||admin_user?
  end
  
  def editor_or_editor_manager_authenticate
    deny_access unless editor_manager_user?||editor_user?||admin_user?
  end
  
  def editor_or_editor_manager_or_supervisor_authenticate
    deny_access unless editor_manager_user?||editor_user?||supervisor_user?||admin_user?
  end
  
  private
  
    def user_from_remember_token 
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token 
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil 
    end
    
end
