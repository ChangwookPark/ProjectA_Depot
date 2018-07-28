// ======================================================================== //
// Copyright 2009-2017 Intel Corporation                                    //
//                                                                          //
// Licensed under the Apache License, Version 2.0 (the "License");          //
// you may not use this file except in compliance with the License.         //
// You may obtain a copy of the License at                                  //
//                                                                          //
//     http://www.apache.org/licenses/LICENSE-2.0                           //
//                                                                          //
// Unless required by applicable law or agreed to in writing, software      //
// distributed under the License is distributed on an "AS IS" BASIS,        //
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. //
// See the License for the specific language governing permissions and      //
// limitations under the License.                                           //
// ======================================================================== //

#include "taskschedulertbb.h"

namespace embree
{
  static bool g_tbb_threads_initialized = false;
  static tbb::task_scheduler_init g_tbb_threads(tbb::task_scheduler_init::deferred);
  
  class TBBAffinity: public tbb::task_scheduler_observer
  {
    tbb::atomic<int> threadCount;
    
  public:
    TBBAffinity() {
      threadCount = 0;
    }
    
    void on_scheduler_entry( bool ) 
    {
      ++threadCount;
      setAffinity(TaskScheduler::threadIndex());
    }
    
    void on_scheduler_exit( bool ) { 
      --threadCount; 
    }
    
  } tbb_affinity;
  
  void TaskScheduler::create(size_t numThreads, bool set_affinity, bool start_threads)
  {
    /* first terminate threads in case we configured them */
    if (g_tbb_threads_initialized) {
      g_tbb_threads.terminate();
      g_tbb_threads_initialized = false;
    }
    
    /* only set affinity if requested by the user */
    if (set_affinity)
      tbb_affinity.observe(true); 
    
    /* now either keep default settings or configure number of threads */
    if (numThreads == 0) {
      g_tbb_threads_initialized = false;
      numThreads = tbb::task_scheduler_init::default_num_threads();
    } else {
      g_tbb_threads_initialized = true;
      g_tbb_threads.initialize(int(numThreads));
    }

    /* start worker threads */
    if (start_threads) 
    {
      BarrierSys barrier(numThreads);
      tbb::parallel_for(size_t(0), size_t(numThreads), size_t(1), [&] ( size_t i ) {
          barrier.wait();
        });
    }
  }
  
  void TaskScheduler::destroy()
  {
    if (g_tbb_threads_initialized) {
      g_tbb_threads.terminate();
      g_tbb_threads_initialized = false;
    }
  }
}
