//
//  BEMCheckBox.swift
//  CheckBox
//
//  Created by Bobo on 9/19/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

import UIKit

/** The BEMCheckBoxDelegate protocol. Used to receive life cycle events. */
@objc public protocol BEMCheckBoxDelegate: NSObjectProtocol {
    /** Sent to the delegate every time the check box gets tapped.
     * @discussion This method gets triggered after the properties are updated (on), but before the animations, if any, are completed.
     * @seealso animationDidStopForCheckBox:
     * @param checkBox The BEMCheckBox instance that has been tapped.
     */
    @objc optional func didTap(_ checkBox: BEMCheckBox)
    
    /** Sent to the delegate every time the check box finishes being animated.
     * @discussion This method gets triggered after the properties are updated (on), and after the animations are completed. It won't be triggered if no animations are started.
     * @seealso didTapCheckBox:
     * @param checkBox The BEMCheckBox instance that was animated.
     */
    @objc optional func animationDidStop(for checkBox: BEMCheckBox)
}

/** Tasteful Checkbox for iOS. */
@IBDesignable
@objc
public class BEMCheckBox: UIControl, CAAnimationDelegate {
    
    @objc(BEMBoxType)
    public enum BoxType : Int {
        /** Circled box. */
        case circle
        
        /** Squared box. */
        case square
    }
    
    @objc(BEMAnimationType)
    public enum AnimationType : Int {
        /** Animates the box and the check as if they were drawn.
         *  Should be used with a clear colored `onFillColor` property. */
        case stroke
        
        /** When tapped, the checkbox is filled from its center.
         * Should be used with a colored `onFillColor` property. */
        case fill
        
        /** Animates the check mark with a bouncy effect.  */
        case bounce
        
        /** Morphs the checkmark from a line.
         * Should be used with a colored `onFillColor` property. */
        case flat
        
        /** Animates the box and check as if they were drawn in one continuous line.
         * Should be used with a clear colored `onFillColor` property. */
        case oneStroke
        
        /** When tapped, the checkbox is fading in or out (opacity). */
        case fade
    }
    
    /** The object that acts as the delegate of the receiving check box.
    * @discussion The delegate must adopt the \p BEMCheckBoxDelegate protocol. The delegate is not retained.
     */
    @objc @IBOutlet weak public var delegate: BEMCheckBoxDelegate?
    
    /** This property allows you to retrieve and set (without animation) a value determining whether the BEMCheckBox object is On or Off.
      * Default to NO.
     */
    @objc @IBInspectable public var on: Bool {
        get { return _on }
        set { self.setOn(newValue) }
    }

    /** The type of box.
     * @see BoxType.
     */
    @objc public var boxType: BoxType = .circle {
        didSet {
            pathManager.boxType = boxType
            setNeedsLayout()
        }
    }
    
    /** The width of the lines of the check mark and the box. Default to 2. */
    @objc @IBInspectable public var lineWidth: CGFloat = 2.0 {
        didSet {
            pathManager.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    /** The corner radius which is applied to the box when the boxType is square. Default to 3.0. */
    @objc @IBInspectable public var cornerRadius: CGFloat = 3.0 {
        didSet {
            pathManager.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }
    
    /** The duration in seconds of the animation when the check box switches from on and off. Default to 0. */
    @objc @IBInspectable public var animationDuration: CFTimeInterval = 0.5 {
        didSet {
            animationManager.animationDuration = animationDuration
        }
    }
    
    /** BOOL to control if the box should be hidden or not. Defaults to NO. */
    @objc @IBInspectable public var hideBox = false
    
    /** The color of the line around the box when it is On. */
    @objc @IBInspectable public var onTintColor: UIColor? = UIColor(red: 0, green: 122.0 / 255.0, blue: 255 / 255, alpha: 1)
    
    /** The color of the inside of the box when it is On. */
    @objc @IBInspectable public var onFillColor: UIColor? = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    /** The color of the inside of the box when it is Off. */
    @objc @IBInspectable public var offFillColor: UIColor? = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    /** The color of the check mark when it is On. */
    @objc @IBInspectable public var onCheckColor: UIColor? = UIColor(red: 0, green: 122.0 / 255.0, blue: 255 / 255, alpha: 1) {
        didSet {
            setNeedsLayout()
        }
    }
    
    /** The layer where the box is drawn when the check box is set to On. */
    private var onBoxLayer: CAShapeLayer?
    
    /** The layer where the box is drawn when the check box is set to Off. */
    private var offBoxLayer: CAShapeLayer?
    
    /** The layer where the check mark is drawn when the check box is set to On. */
    private var checkMarkLayer: CAShapeLayer?
    
    /** The BEMAnimationManager object used to generate animations. */
    private lazy var animationManager: BEMAnimationManager = {
        let animationManager = BEMAnimationManager(animationDuration: animationDuration)
        return animationManager
    }()


    /** The BEMPathManager object used to generate paths. */
    private lazy var pathManager: BEMPathManager = {
        let pathManager = BEMPathManager()
        pathManager.lineWidth = lineWidth
        pathManager.cornerRadius = cornerRadius
        pathManager.boxType = boxType
        pathManager.size = frame.height
        return pathManager
    }()
    
    /** The group this box is associated with. */
    @objc public var group: BEMCheckBoxGroup?
    
    /** The animation type when the check mark gets set to On.
     * @warning Some animations might not look as intended if the different colors of the control are not appropriatly configured.
     * @see BEMAnimationType.
     */
    @objc public var onAnimationType: AnimationType = .stroke
    
    /** The animation type when the check mark gets set to Off.
     * @warning Some animations might not look as intended if the different colors of the control are not appropriatly configured.
     * @see BEMAnimationType.
     */
    @objc public var offAnimationType: AnimationType = .stroke
    
    /** If the checkbox width or height is smaller than this value, the touch area will be increased. Allows for visually small checkboxes to still be easily tapped. Default: (44,  */
    @objc @IBInspectable var minimumTouchSize = CGSize(width: 44, height: 44)
    
    // MARK: Initialization
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @objc required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Default values
        tintColor = UIColor.lightGray
        backgroundColor = UIColor.clear

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapCheckBox(_:))))
    }
    
    public override var frame: CGRect {
        didSet {
            pathManager.size = frame.height
        }
    }

    override public func layoutSubviews() {
        self.setupLayers()
    }

    override public var intrinsicContentSize: CGSize {
        return frame.size
    }
    
    // MARK: Setters
    
    private var _on: Bool = false
    
    internal func setOn(_ on: Bool, animated: Bool, notifyGroup: Bool) {
        self._on = on

        if animated {
            setupLayers()
        } else {
            setNeedsLayout()
        }

        if on {
            if animated {
                addOnAnimation()
            }
        } else {
            if animated {
                addOffAnimation()
            } else {
                onBoxLayer?.removeFromSuperlayer()
                onBoxLayer = nil
                
                checkMarkLayer?.removeFromSuperlayer()
                checkMarkLayer = nil
            }
        }

        if notifyGroup {
            group?.notifyCheckBoxSelectionChanged(self)
        }
    }
    
    /** Set the state of the check box to On or Off, optionally animating the  */
    @objc public func setOn(_ on: Bool, animated: Bool = false) {
        setOn(on, animated: animated, notifyGroup: false)
    }
    
    // MARK: Gesture Recognizer
    @objc func handleTapCheckBox(_ recognizer: UITapGestureRecognizer?) {
        // If we have a group that requires a selection, and we're already selected, don't allow a deselection
        if group != nil && group?.mustHaveSelection == true && on {
            return
        }

        setOn(!on, animated: true)
        if delegate?.responds(to: #selector(BEMCheckBoxDelegate.didTap(_:))) == true {
            delegate?.didTap?(self)
        }
        sendActions(for: .valueChanged)
    }

    // MARK: - Helper methods -

    // MARK: Increase touch area
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var found = super.point(inside: point, with: event)

        let minimumSize = minimumTouchSize
        let width = bounds.width
        let height = bounds.height

        if found == false && (width < minimumSize.width || height < minimumSize.height) {
            let increaseWidth = minimumSize.width - width
            let increaseHeight = minimumSize.height - height

            let rect = bounds.insetBy(dx: -increaseWidth / 2, dy: -increaseHeight / 2)

            found = rect.contains(point)
        }

        return found
    }

    // MARK: Drawings

    /** Draws the entire checkbox, depending on the current state of the on property. */
    private func setupLayers() {
        if !hideBox {
            setupBoxOffLayer()
        } else {
            offBoxLayer?.removeFromSuperlayer()
            offBoxLayer = nil
        }
        
        if !hideBox && on {
            setupBoxOnLayer()
        }
        
        if on {
            setupCheckmarkLayer()
        }
    }

    /** Draws the box used when the checkbox is set to Off. */
    private func setupBoxOffLayer() {
        if offBoxLayer == nil {
            offBoxLayer = CAShapeLayer()
            offBoxLayer?.rasterizationScale = 2.0 * UIScreen.main.scale
            offBoxLayer?.shouldRasterize = true
        }
        
        offBoxLayer?.frame = bounds
        offBoxLayer?.path = pathManager.pathForBox().cgPath
        offBoxLayer?.fillColor = offFillColor?.cgColor
        offBoxLayer?.strokeColor = tintColor?.cgColor
        offBoxLayer?.lineWidth = lineWidth
        
        self.layer.insertSublayer(offBoxLayer!, at: 0)
    }
    
    /** Draws the box when the checkbox is set to On.
     */
    private func setupBoxOnLayer() {
        if onBoxLayer == nil {
            onBoxLayer = CAShapeLayer()
            onBoxLayer?.rasterizationScale = 2.0 * UIScreen.main.scale
            onBoxLayer?.shouldRasterize = true
        }
        
        onBoxLayer?.frame = bounds
        onBoxLayer?.path = pathManager.pathForBox().cgPath
        onBoxLayer?.lineWidth = lineWidth
        onBoxLayer?.fillColor = onFillColor?.cgColor
        onBoxLayer?.strokeColor = onTintColor?.cgColor
        
        layer.addSublayer(onBoxLayer!)
    }

    /** Draws the check mark when the checkbox is set to On.
     */
    private func setupCheckmarkLayer() {
        if checkMarkLayer == nil {
            checkMarkLayer = CAShapeLayer()
            checkMarkLayer?.rasterizationScale = 2.0 * UIScreen.main.scale
            checkMarkLayer?.shouldRasterize = true
            checkMarkLayer?.lineCap = .round
            checkMarkLayer?.lineJoin = .round
        }
        
        checkMarkLayer?.frame = bounds
        checkMarkLayer?.path = pathManager.pathForCheckMark().cgPath
        checkMarkLayer?.strokeColor = onCheckColor?.cgColor
        checkMarkLayer?.lineWidth = lineWidth
        checkMarkLayer?.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(checkMarkLayer!)
    }

    // MARK: Animations
    
    private func addOnAnimation() {
        if animationDuration == 0.0 {
            return
        }
        
        switch onAnimationType {
        case .stroke:
            let animation = animationManager.strokeAnimationReverse(false)
            onBoxLayer?.add(animation, forKey: "strokeEnd")
            animation.delegate = self
            checkMarkLayer?.add(animation, forKey: "strokeEnd")
            
            return
            
        case .fill:
            let wiggle = animationManager.fillAnimation(withBounces: 1, amplitude: 0.18, reverse: false)
            onBoxLayer?.add(wiggle, forKey: "transform")
            
            let opacityAnimation = animationManager.opacityAnimationReverse(false)
            opacityAnimation.delegate = self
            checkMarkLayer?.add(opacityAnimation, forKey: "opacity")
            
            return
            
        case .bounce:
            let amplitude: CGFloat = (boxType == .square) ? 0.20 : 0.35
            
            let wiggle = animationManager.fillAnimation(withBounces: 1, amplitude: amplitude, reverse: false)
            wiggle.delegate = self
            checkMarkLayer?.add(wiggle, forKey: "transform")
            
            let opacity = animationManager.opacityAnimationReverse(false)
            opacity.duration = animationDuration / 1.4
            onBoxLayer?.add(opacity, forKey: "opacity")
            
            return
            
        case .flat:
            let morphAnimation = animationManager.morphAnimation(
                from: pathManager.pathForFlatCheckMark(),
                to: pathManager.pathForCheckMark())
            let opacity = animationManager.opacityAnimationReverse(false)
            
            morphAnimation.delegate = self
            opacity.duration = animationDuration / 5
            
            onBoxLayer?.add(opacity, forKey: "opacity")
            checkMarkLayer?.add(morphAnimation, forKey: "path")
            checkMarkLayer?.add(opacity, forKey: "opacity")
            
            return
            
        case .oneStroke:
            // Temporary set the path of the checkmark to the long checkmark
            self.checkMarkLayer?.path = pathManager.pathForLongCheckMark().reversing().cgPath
            
            let boxStrokeAnimation = animationManager.strokeAnimationReverse(false)
            let checkStrokeAnimation = animationManager.strokeAnimationReverse(false)
            let checkMorphAnimation = animationManager.morphAnimation(
                from: pathManager.pathForLongCheckMark(),
                to: pathManager.pathForCheckMark())
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2
            onBoxLayer?.add(boxStrokeAnimation, forKey: "strokeEnd")
            
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 3
            checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            checkStrokeAnimation.fillMode = .backwards
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration
            checkMarkLayer?.add(checkStrokeAnimation, forKey: "strokeEnd")
            
            checkMorphAnimation.duration = checkMorphAnimation.duration / 6
            checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            checkMorphAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration + checkStrokeAnimation.duration
            checkMorphAnimation.isRemovedOnCompletion = false
            checkMorphAnimation.fillMode = .forwards
            checkMorphAnimation.delegate = self
            checkMarkLayer?.add(checkMorphAnimation, forKey: "path")
            
            return
            
        default:
            let animation = animationManager.opacityAnimationReverse(false)
            onBoxLayer?.add(animation, forKey: "opacity")
            animation.delegate = self
            checkMarkLayer?.add(animation, forKey: "opacity")
            
            return
        }
    }
    
    private func addOffAnimation() {
        if animationDuration == 0.0 {
            onBoxLayer?.removeFromSuperlayer()
            onBoxLayer = nil
            
            checkMarkLayer?.removeFromSuperlayer()
            checkMarkLayer = nil
            return
        }
                
        switch offAnimationType {
        case .stroke:
            let animation = animationManager.strokeAnimationReverse(true)
            onBoxLayer?.add(animation, forKey: "strokeEnd")
            animation.delegate = self
            checkMarkLayer?.add(animation, forKey: "strokeEnd")
            
            return
            
        case .fill:
            let wiggle = animationManager.fillAnimation(withBounces: 1, amplitude: 0.18, reverse: true)
            wiggle.duration = animationDuration
            wiggle.delegate = self
            onBoxLayer?.add(wiggle, forKey: "transform")
            
            let opacity = animationManager.opacityAnimationReverse(true)
            checkMarkLayer?.add(opacity, forKey: "opacity")
            
            return
            
        case .bounce:
            let amplitude: CGFloat = (boxType == .square) ? 0.20 : 0.35
            let wiggle = animationManager.fillAnimation(withBounces: 1, amplitude: amplitude, reverse: true)
            wiggle.duration = animationDuration / 1.1
            checkMarkLayer?.add(wiggle, forKey: "transform")
            
            let opacity = animationManager.opacityAnimationReverse(true)
            opacity.delegate = self
            onBoxLayer?.add(opacity, forKey: "opacity")
            
            return
            
        case .flat:
            let morphAnimation = animationManager.morphAnimation(
                from: pathManager.pathForCheckMark(),
                to: pathManager.pathForFlatCheckMark())
            let opacity = animationManager.opacityAnimationReverse(true)
            
            morphAnimation.delegate = self
            opacity.duration = animationDuration
            
            onBoxLayer?.add(opacity, forKey: "opacity")
            checkMarkLayer?.add(morphAnimation, forKey: "path")
            checkMarkLayer?.add(opacity, forKey: "opacity")
            
            return
            
        case .oneStroke:
                checkMarkLayer?.path = pathManager.pathForLongCheckMark().reversing().cgPath
            
            let checkMorphAnimation = animationManager.morphAnimation(
                from: pathManager.pathForCheckMark(),
                to: pathManager.pathForLongCheckMark())
            let checkStrokeAnimation = animationManager.strokeAnimationReverse(true)
            
            checkMorphAnimation.delegate = nil
            checkMorphAnimation.duration = CFTimeInterval(checkMorphAnimation.duration / 6)
            checkMarkLayer?.add(checkMorphAnimation, forKey: "path")
            
            checkStrokeAnimation.delegate = nil
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration
            checkStrokeAnimation.duration = CFTimeInterval(checkStrokeAnimation.duration / 3)
            checkMarkLayer?.add(checkStrokeAnimation, forKey: "strokeEnd")
            
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Double(Int64(CACurrentMediaTime() +
                    checkMorphAnimation.duration + checkStrokeAnimation.duration *
                    Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                execute: {
                    weakSelf?.checkMarkLayer?.lineCap = .butt
            })
            
            let boxStrokeAnimation = animationManager.strokeAnimationReverse(true)
            boxStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            boxStrokeAnimation.duration = CFTimeInterval(boxStrokeAnimation.duration / 2)
            boxStrokeAnimation.delegate = self
            onBoxLayer?.add(boxStrokeAnimation, forKey: "strokeEnd")
            
            return
            
        default:
            let animation = animationManager.opacityAnimationReverse(true)
            onBoxLayer?.add(animation, forKey: "opacity")
            animation.delegate = self
            checkMarkLayer?.add(animation, forKey: "opacity")
            
            return
        }
    }
    
    // MARK: Animation Delegate
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true && on == false {
            onBoxLayer?.removeFromSuperlayer()
            onBoxLayer = nil
            
            checkMarkLayer?.removeFromSuperlayer()
            checkMarkLayer = nil
        }
        
        if delegate?.responds(to: #selector(BEMCheckBoxDelegate.animationDidStop(for:))) == true {
            delegate?.animationDidStop?(for: self)
        }
    }
}


