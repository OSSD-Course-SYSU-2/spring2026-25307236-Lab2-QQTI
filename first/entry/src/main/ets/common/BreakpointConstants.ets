/**
 * 断点常量定义与一多响应式工具类
 *
 * 基于 HarmonyOS 一多断点规范：
 *   xs: [0, 320)   - 超小屏（手表）
 *   sm: [320, 600) - 小屏（手机竖屏）
 *   md: [600, 840) - 中屏（折叠屏、小平板）
 *   lg: [840, +∞)  - 大屏（平板横屏、PC/2in1）
 */
import { window } from '@kit.ArkUI';

export enum Breakpoint {
  XS = 'xs',
  SM = 'sm',
  MD = 'md',
  LG = 'lg'
}

export interface ResponsiveStyle {
  /** 容器最大宽度 (vp) */
  maxWidth: number | string;
  /** 内容区左右 padding (vp) */
  contentPadding: number;
  /** 标题字号 */
  titleFontSize: number;
  /** 正文字号 */
  bodyFontSize: number;
  /** 小提示字号 */
  captionFontSize: number;
  /** 按钮宽度 */
  buttonWidth: number;
  /** 按钮高度 */
  buttonHeight: number;
  /** 按钮字号 */
  buttonFontSize: number;
  /** 组件间距 */
  spacing: number;
  /** 卡片圆角 */
  borderRadius: number;
  /** 视频高度 */
  videoHeight: number;
  /** 视频宽度占比 */
  videoWidthPercent: string;
  /** 是否是宽屏布局（横排） */
  isWideLayout: boolean;
}

export class BreakpointConstants {
  /** 断点宽度阈值 (vp) */
  static readonly THRESHOLD_XS = 0;
  static readonly THRESHOLD_SM = 320;
  static readonly THRESHOLD_MD = 600;
  static readonly THRESHOLD_LG = 840;

  /**
   * 根据窗口宽度计算当前断点
   */
  static getBreakpoint(width: number): Breakpoint {
    if (width < BreakpointConstants.THRESHOLD_SM) {
      return Breakpoint.XS;
    } else if (width < BreakpointConstants.THRESHOLD_MD) {
      return Breakpoint.SM;
    } else if (width < BreakpointConstants.THRESHOLD_LG) {
      return Breakpoint.MD;
    } else {
      return Breakpoint.LG;
    }
  }

  /** 判断是否为小屏设备 */
  static isPhone(breakpoint: Breakpoint): boolean {
    return breakpoint === Breakpoint.SM || breakpoint === Breakpoint.XS;
  }

  /** 判断是否为平板类设备 */
  static isTablet(breakpoint: Breakpoint): boolean {
    return breakpoint === Breakpoint.MD;
  }

  /** 判断是否为大屏/PC设备 */
  static isLargeScreen(breakpoint: Breakpoint): boolean {
    return breakpoint === Breakpoint.LG;
  }

  /** 判断是否为宽屏设备 */
  static isWideScreen(breakpoint: Breakpoint): boolean {
    return breakpoint === Breakpoint.MD || breakpoint === Breakpoint.LG;
  }

  /**
   * 获取响应式布局样式
   * 根据断点返回一组预定义的尺寸参数，各页面直接使用
   */
  static getResponsiveStyle(breakpoint: Breakpoint): ResponsiveStyle {
    switch (breakpoint) {
      case Breakpoint.XS:
        return {
          maxWidth: '100%',
          contentPadding: 12,
          titleFontSize: 24,
          bodyFontSize: 14,
          captionFontSize: 11,
          buttonWidth: 180,
          buttonHeight: 48,
          buttonFontSize: 16,
          spacing: 12,
          borderRadius: 8,
          videoHeight: 200,
          videoWidthPercent: '95%',
          isWideLayout: false
        };

      case Breakpoint.SM:
        return {
          maxWidth: '100%',
          contentPadding: 20,
          titleFontSize: 34,
          bodyFontSize: 16,
          captionFontSize: 13,
          buttonWidth: 220,
          buttonHeight: 55,
          buttonFontSize: 20,
          spacing: 20,
          borderRadius: 12,
          videoHeight: 350,
          videoWidthPercent: '95%',
          isWideLayout: false
        };

      case Breakpoint.MD:
        return {
          maxWidth: 560,
          contentPadding: 32,
          titleFontSize: 40,
          bodyFontSize: 18,
          captionFontSize: 14,
          buttonWidth: 260,
          buttonHeight: 60,
          buttonFontSize: 22,
          spacing: 24,
          borderRadius: 16,
          videoHeight: 420,
          videoWidthPercent: '90%',
          isWideLayout: false
        };

      case Breakpoint.LG:
      default:
        return {
          maxWidth: 680,
          contentPadding: 40,
          titleFontSize: 46,
          bodyFontSize: 20,
          captionFontSize: 15,
          buttonWidth: 300,
          buttonHeight: 65,
          buttonFontSize: 24,
          spacing: 28,
          borderRadius: 20,
          videoHeight: 500,
          videoWidthPercent: '80%',
          isWideLayout: true
        };
    }
  }

  /**
   * 复制一份样式并应用覆盖值
   */
  private static cloneStyle(
    base: ResponsiveStyle,
    overrides: Partial<ResponsiveStyle>
  ): ResponsiveStyle {
    const result: ResponsiveStyle = {
      maxWidth: base.maxWidth,
      contentPadding: base.contentPadding,
      titleFontSize: base.titleFontSize,
      bodyFontSize: base.bodyFontSize,
      captionFontSize: base.captionFontSize,
      buttonWidth: base.buttonWidth,
      buttonHeight: base.buttonHeight,
      buttonFontSize: base.buttonFontSize,
      spacing: base.spacing,
      borderRadius: base.borderRadius,
      videoHeight: base.videoHeight,
      videoWidthPercent: base.videoWidthPercent,
      isWideLayout: base.isWideLayout
    };
    if (overrides.maxWidth !== undefined) {
      result.maxWidth = overrides.maxWidth;
    }
    if (overrides.contentPadding !== undefined) {
      result.contentPadding = overrides.contentPadding;
    }
    if (overrides.videoHeight !== undefined) {
      result.videoHeight = overrides.videoHeight;
    }
    if (overrides.videoWidthPercent !== undefined) {
      result.videoWidthPercent = overrides.videoWidthPercent;
    }
    if (overrides.isWideLayout !== undefined) {
      result.isWideLayout = overrides.isWideLayout;
    }
    return result;
  }

  /**
   * 获取视频页面的响应式布局样式
   * 在大屏上采用左右分栏布局，小屏上采用上下布局
   */
  static getVideoPageStyle(breakpoint: Breakpoint): ResponsiveStyle {
    const base = BreakpointConstants.getResponsiveStyle(breakpoint);
    switch (breakpoint) {
      case Breakpoint.LG:
        return BreakpointConstants.cloneStyle(base, {
          maxWidth: 1200,
          contentPadding: 48,
          videoHeight: 450,
          videoWidthPercent: '100%',
          isWideLayout: true
        });
      case Breakpoint.MD:
        return BreakpointConstants.cloneStyle(base, {
          maxWidth: 720,
          contentPadding: 36,
          videoHeight: 380,
          videoWidthPercent: '100%',
          isWideLayout: false
        });
      default:
        return base;
    }
  }
}

/**
 * 响应式窗口监听工具
 * 在页面中调用 initBreakpointObserver 即可自动监听窗口变化
 */
export class BreakpointObserver {
  private currentBreakpoint: Breakpoint = Breakpoint.SM;
  private onChangeCallback?: (bp: Breakpoint) => void;

  /**
   * 初始化断点监听，需要在 aboutToAppear 中调用
   * @param uiContext UIContext 实例，通过 this.getUIContext() 获取
   * @param callback 断点变化时的回调
   */
  init(uiContext: UIContext, callback: (bp: Breakpoint) => void): void {
    this.onChangeCallback = callback;

    try {
      const win = window.getLastWindow(uiContext.getHostContext());
      win.then((windowClass: window.Window) => {
        // 初始断点
        const rect = windowClass.getWindowProperties().windowRect;
        const width = uiContext.px2vp(rect.width);
        this.currentBreakpoint = BreakpointConstants.getBreakpoint(width);
        callback(this.currentBreakpoint);

        // 监听窗口大小变化
        windowClass.on('windowSizeChange', (size: window.Size) => {
          const newWidth = uiContext.px2vp(size.width);
          const newBreakpoint = BreakpointConstants.getBreakpoint(newWidth);
          if (newBreakpoint !== this.currentBreakpoint) {
            this.currentBreakpoint = newBreakpoint;
            callback(newBreakpoint);
          }
        });
      });
    } catch (e) {
      console.error('BreakpointObserver init failed: ' + e);
    }
  }
}
