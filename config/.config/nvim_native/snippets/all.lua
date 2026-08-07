return {

	{
		trigger = "date",
		body = {
			os.date("%Y/%m/%d"),
		},
	},

	{
		trigger = "time",
		body = {
			os.date("%H:%M:%S"),
		},
	},

	{
		trigger = "mail",
		body = {
			"ryossj@gmail.com",
		},
	},

	{
		trigger = "email",
		body = {
			"ryossj@gmail.com",
		},
	},

	{
		trigger = "uvm",
		body = {
			"@uvm.edu",
		},
	},

	{
		trigger = "gh",
		body = {
			"github.com/Rouzihiro",
		},
	},

	{
		trigger = "regards",
		body = {
			"Kind regards, [Rey Z.](https://github.com/Rouzihiro/dotfiles)",
		},
	},

	{
		trigger = "ciao",
		body = {
			"Kind regards, [Rey Z.](https://github.com/Rouzihiro/dotfiles)",
		},
	},

	{
		trigger = "(",
		body = {
			"($1)",
		},
	},

	{
		trigger = "[",
		body = {
			"[$1]",
		},
	},

	{
		trigger = "{",
		body = {
			"{$1}",
		},
	},

	{
		trigger = "$",
		body = {
			"$1$",
		},
	},

	{
		trigger = "script",
		body = {
			"#!/bin/bash",
			"source fzf_selector.sh",
			"$1",
		},
	},

	{
		trigger = "bash",
		body = {
			"#!/usr/bin/env bash",
			"$1",
		},
	},

	{
		trigger = "sh",
		body = {
			"#!/usr/bin/env sh",
			"$1",
		},
	},

	{
		trigger = "link",
		body = {
			"[$1]($2)",
		},
	},

	{
		trigger = "img",
		body = {
			"![$1]($2)",
		},
	},

	{
		trigger = "par",
		body = {
			"#par(first-line-indent: 3em)[",
			"    $1",
			"]",
		},
	},
}
