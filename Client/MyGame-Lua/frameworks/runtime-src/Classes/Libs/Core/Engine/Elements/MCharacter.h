#pragma once
#ifndef __MCharacter_H__
#define __MCharacter_H__

/**
* <p>A Character is a dynamic object in the scene. Characters can move and rotate, and can be added and
* removed from the scene at any time. Live creatures and vehicles are the most common
* uses for the fCharacter class.</p>
*
* <p>There are other uses for fCharacter: If you want a chair to be "moveable", for example, you
* will have to make it a fCharacter.</p>
*
* <p>You can add the parameter dynamic="true" to the XML definition for any object you want to be able to move
* later. This will force the engine to make that object a Character.</p>
*
* <p>The main reason of having different classes for static and dynamic objects is that static objects can be
* added to the light rendering cache along with floors and walls, whereas dynamic objects (characters) can't.</p>
*
* <p>Don't use this class to implement bullets. Use the fBullet class.</p>
*
* <p>YOU CAN'T CREATE INSTANCES OF THIS ELEMENT DIRECTLY.<br>
* Use scene.createCharacter() to add new characters to an scene.</p>
*
* @see org.ffilmation.engine.core.fScene#createCharacter()
*
*/
class fCharacter : public MSceneObject, public MMovingElement
{

};

#endif