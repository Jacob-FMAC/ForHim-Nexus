import 'package:flutter/material.dart';
import '../config/theme_config.dart';

void showAnnouncementModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ThemeConfig.surfaceDark.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeConfig.neonCyan.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: ThemeConfig.neonCyan.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '公告 / ANNOUNCEMENT',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.neonCyan,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '义卖会电子设备展览公告\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                        TextSpan(
                          text: 'From Analog to Intelligent｜消费电子的时代演进（1976–2022）\n\n',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        TextSpan(
                          text: '本次 ForHim Electronics Research Club 电子设备展览以"消费电子设备的发展与变迁"为核心主题，系统性回顾1976年至2022年前后的消费电子发展历程，完整呈现个人电子设备从基础通信工具逐步演进为现代智能生态终端的技术路径。\n\n'
                              '展览通过跨时代、跨品牌与跨操作系统的经典电子产品进行串联展示，涵盖Apple、Nokia、Motorola、HTC、Samsung、BlackBerry等多个具有代表性的厂商体系。展品范围覆盖早期移动通信设备、功能机时代产品、个人数字助理（PDA）、早期智能手机以及现代触屏智能设备，构成一条清晰的技术演进时间轴。\n\n'
                              '整个展览按照三个核心分区进行组织：\n\n'
                              '第一部分为「通信的起点」，展示早期移动通信设备与功能机时代产品。这一阶段设备以按键输入与语音通信为核心功能，结构厚重但技术意义重大，奠定了蜂窝通信、短信系统与个人移动终端的基础框架。\n\n'
                              '第二部分为「智能时代的重构者」，集中展示Apple生态体系下的核心设备。从iPod到iPhone，再到iPad与Mac系列，Apple通过统一的工业设计语言与系统生态，推动了多点触控交互、移动应用生态与现代智能设备形态的形成，成为整个展览的核心叙事轴线。\n\n'
                              '第三部分为「全面智能化时代」，展示2010年以后多品牌并行发展的智能设备体系。该阶段以安卓阵营、跨生态设备与多功能智能终端为代表，体现出性能提升、功能融合与生态竞争并存的发展趋势，最终形成今天高度互联的数字生活结构。\n\n'
                              '部分展品支持开机展示与基础交互体验，观众可近距离观察不同时代设备的界面设计、操作逻辑与工业设计语言。从物理按键到触控交互，从单一通信工具到多任务智能平台，直观感受消费电子技术的结构性跃迁。\n\n'
                              '从更宏观的角度来看，这一跨越近半个世纪的发展历程，本质上是信息技术不断微型化、移动化与智能化的过程。设备不再仅仅作为工具存在，而逐渐演变为信息入口、内容平台与个人数字生活的核心载体。\n\n'
                              '因此，本次展览不仅是一场关于电子产品的历史回顾，更是一条关于"人类如何与技术共同演进"的时间叙事。在真实设备的对比与时代更替中，观众将能够更清晰地理解当下数字世界的形成逻辑与未来发展方向。\n\n'
                              '⚠ 展览注意事项\n\n'
                              '1.\n本次展览禁止幼儿园儿童进入。\n\n'
                              '2.\n请勿触碰未标注"可互动"标识的展品设备。未经许可擅自触碰或造成损坏的，将依据市场拍卖价值或捐赠者意愿进行相应赔偿。\n\n'
                              '3.\n场内禁止携带及食用零食、饮料等食品。\n\n'
                              '4.\n如需重复入场，请于入口处重新登记确认信息。\n\n'
                              '本展览仅为义卖活动附属展区内容，进入预约系统即视为已阅读并理解以上全部展览说明。',
                        ),
                      ],
                    ),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
