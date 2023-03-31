import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAnimation({Key?key,
    this.duration=const Duration(microseconds: 150),
    required this.child,
    required this.isAnimating,
    this.onEnd,
    this.smallLike=false,
  }) :super(key: key);
  @override
  _LikeAnimationState createState()=>_LikeAnimationState();
}
class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scale;
  void initState(){
    super.initState();
    controller=AnimationController(vsync: this,duration:Duration(
        microseconds:widget.duration.inMilliseconds ~/2,
    ),
    );
    scale=Tween<double>(begin: 1,end: 1.2).animate(controller);
  }
  void didUpdatedWidget(covariant LikeAnimation oldWidget){
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimating!=oldWidget.isAnimating){
      startAnimation();
    }
  }
  startAnimation() async{
    if(widget.isAnimating || widget.smallLike){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(microseconds: 200),);
      if(widget.onEnd!=null){
        widget.onEnd!();
      }
    }
  }
  void dispose(){
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale:scale,
      child: widget.child,
    );
  }
  }
