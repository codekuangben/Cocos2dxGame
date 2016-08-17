#pragma once
#ifndef __MProcessEvent_H__
#define __MProcessEvent_H__

/**
* <p>The fProcessEvent event class stores information about a process event.</p>
*
* <p>Several processes in the filmation engine involve more than one subprocess,
* and this class stores info about the overall task that is being monitored as
* well as the status of the current subtask.</p>
*
* <p>This allows to have progress bars that go something like:</p>
*
* Loading media file A. 20% done<br>
* Overall loading process: 12% done
*
*/
class MProcessEvent : public Event
{
public:
	MProcessEvent();
	~MProcessEvent();

	// Public

	/**
	* Overall process completion status, from 0 to 100
	*/
	public var overall : Number;

	/**
	* Overall process description
	*/
	public var overallDescription : String;

	/**
	* Current process completion status, from 0 to 100
	*/
	public var current : Number;

	/**
	* Current process description
	*/
	public var currentDescription : String;

	/**
	* A boolean value indicating if the overall process is considered done ( same as checking overall = 100 )
	*/
	public var complete : Boolean;
};

#endif