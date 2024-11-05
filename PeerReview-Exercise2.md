# Code Review for Programming Exercise 2 #
## Description ##

For this assignment, you will be giving feedback on the completeness of Exercise 1.  To do so, we will be giving you a rubric to provide feedback on. For the feedback, please provide positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to review the code and project files that were given out by the instructor.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.

## Due Date and Submission Information ##
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer-review. The file name should be the same as in the template: PeerReview-Exercise1.md. You also need to include your name and email address in the Peer-reviewer Information section below. This review document should be placed into the base folder of the repo you are reviewing in the master branch. This branch should be on the origin of the repository you are reviewing.

If you are in the rare situation where there are two peer-reviewers on a single repository, append your UC Davis user name before the extension of your review file. An example: PeerReview-Exercise1-username.md. Both reviewers should submit their reviews in the master branch.  

## Solution Assessment ##

## Peer-reviewer Information

* *name:* [James Xu] 
* *email:* [zhcxu@ucdavis.edu]

### Description ###

To assess the solution, you will be choosing ONE choice from unsatisfactory, satisfactory, good, great, or perfect. Place an x character inside of the square braces next to the appropriate label.

The following are the criteria by which you should assess your peer's solution of the exercise's stages.

#### Perfect #### 
    Cannot find any flaws concerning the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    A major flaw and some minor flaws.

#### Satisfactory ####
    A couple of major flaws. Heading towards a solution, however, did not fully realize the solution.

#### Unsatisfactory ####
    Partial work, but not really converging to a solution. Pervasive major flaws. Objective largely unmet.


### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification ##### 
The camera is always centered on the Vessel, and a 5 by 5 units cross is drawn on the screen which satisfies all stage objectives.


### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

#### Justification ##### 
The required exported fields `top_left`, `bottom_right`, and `autoscroll_speed` is not correctly applied to the camera and the frame border box is not drawn. The camera does move in the x direction but still acts somewhat like a pushbox camera. Overall this seems like partial work and the stage objectives are largely unmet.

### Stage 3 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### justification ##### 
The camera correctly approaches the vessel's position with applied `follow_speed` when moving, and `catchup_speed` when not moving. There is a 5 by 5 unit cross drawn across the screen. One major flaw is that the exported `leash_distance` does not work in the camera logic. The vessel can exceed the leash distance from the camera. Minor improvements can be made to make the camera movement smoother.

### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### justification ##### 
The camera leads the vessel in the direction of the input with `lead_speed` and `leash_distance` is correctly applied. When the vessel stops moving, there is `catchup_delay_duration` applied before camera catch up with `catchup_speed`. This satisfies all stage objectives.

### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

#### justification ##### 
The push box and speed up zone border boxes are drawn correctly based on the exported fields. The camera only moves in the z-axis (not x-axis) direction of the input multiplied by the push ratio while inside the push box. The vessel can move out of the box edge and go out of frame while touching the top and bottom edges of the push box, but works properly along the x-axis when touching an edge. These are major flaws that need fixing but it is heading towards a solution.

## Code Style ##

### Description ###
Check the scripts to see if the student code follows the .Net style guide.

If sections don't adhere to the style guide, please permalink the line of code from GitHub and justify why the line of code has infractions of the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Here is an example of the permalink drop-down on GitHub.

![Permalink option](../images/permalink_example.png)

Here is another example as well.

* [I go to Github and look at the ICommand script in the ECS189L repo!](https://github.com/dr-jam/ECS189L/blob/1618376092e85ffd63d3af9d9dcc1f2078df2170/Projects/CommandPatternExample/Assets/Scripts/ICommand.cs#L5)

### Code Style Review ###

#### Style Guide Infractions ####
* Coding conventions were followed correctly for the most part. I did notice some minor inconsistencies with formatting and comments.

* In the new camera scripts, [functions definitions should be surrounded with two blank lines](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/blob/ae46fd8efb90ce4d14e8f3f83d6dd02d3d4a8579/Obscura/scripts/camera_controllers/speed_up_camera.gd#L53) instead of one.

* There are some inconsistencies in the formatting of comments. [Normal comments that are not disabled code should start with a space after "#"](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/blob/ae46fd8efb90ce4d14e8f3f83d6dd02d3d4a8579/Obscura/scripts/camera_controllers/auto_scroll.gd#L34). 

* [These long conditional statements can be wrapped into multiple lines to improve readability, without exceeding 100 characters on a single line.](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/blob/ae46fd8efb90ce4d14e8f3f83d6dd02d3d4a8579/Obscura/scripts/camera_controllers/speed_up_camera.gd#L35)

#### Style Guide Exemplars ####
* [Whitespace is correctly applied around operators and commas.](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/blob/ae46fd8efb90ce4d14e8f3f83d6dd02d3d4a8579/Obscura/scripts/camera_controllers/speed_up_camera.gd#L30).
* There are detailed comments in script functions, typically with [a space followed after "#" for normal comments](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/blob/ae46fd8efb90ce4d14e8f3f83d6dd02d3d4a8579/Obscura/scripts/camera_controllers/follow_camera_2.gd#L37).


## Best Practices ##

### Description ###

If the student has followed best practices (Unity coding conventions from the StyleGuides document), then feel free to point at these segments of code as examples. 

If the student has breached the best practices and has done something that should be noted, please add the infracture.

This should be similar to the Code Style justification.

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

### Best Practices Review ###

#### Best Practices Infractions ####
* There are several unused exported variables added to [`camera_controller_base.gd`](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/blob/ae46fd8efb90ce4d14e8f3f83d6dd02d3d4a8579/Obscura/scripts/camera_controllers/camera_controller_base.gd#L13). I didn't see the use for them in camera scripts so these can probably be removed.

* There is a minor typo on the file name of [`center_camear.gd`](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/blob/master/Obscura/scripts/camera_controllers/center_camear.gd).

#### Best Practices Exemplars ####
* All scripts are readable and easy to go over. I like how there are comments [inside of functions to describe camera logic](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/blob/ae46fd8efb90ce4d14e8f3f83d6dd02d3d4a8579/Obscura/scripts/camera_controllers/follow_camera_2.gd#L34).

* The new camera script files are well organized under the [scripts/camera_controllers](https://github.com/ensemble-ai/exercise-2-camera-control-Phdery/tree/master/Obscura/scripts/camera_controllers) which made it easy for me to find.