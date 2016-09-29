#!/bin/bash
pactl list sinks | grep Name: | sed "s/Name: //g" | while read line; do
	pactl set-sink-mute $line toggle
done
