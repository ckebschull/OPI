/* OPI: Orbital Propagation Interface
 * Copyright (C) 2014 Institute of Aerospace Systems, TU Braunschweig, All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */
#ifndef OPI_HOST_PROPAGATOR_PLUGIN_H
#define OPI_HOST_PROPAGATOR_PLUGIN_H
#include "../opi_propagator.h"
#include "opi_pluginprocs.h"
namespace OPI
{
	class Plugin;

	/**
	 * \cond INTERNAL_DOCUMENTATION
	 */
	class PropagatorPlugin:
			public Propagator
	{
		public:
			PropagatorPlugin(Plugin* _plugin);
			~PropagatorPlugin();


			virtual ErrorCode enable();
			virtual ErrorCode disable();
            virtual ErrorCode runPropagation(Population& population, double julian_day, double dt, PropagationMode mode, IndexList* indices);
			virtual int requiresCUDA();
		private:
			Plugin* plugin;
			// propagate proc
			pluginPropagateFunction proc_propagate;
			pluginInitFunction proc_init;

	};

	/**
	 * \endcond INTERNAL_DOCUMENTATION
	 */
}


#endif
